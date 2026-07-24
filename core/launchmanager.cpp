#include "launchmanager.h"
#include <QProcess>
#include <QDir>
#include <QFileInfo>
#include <QDebug>
#include <QXmlStreamReader>
#include <QVariantMap>

LaunchManager::LaunchManager(QObject* parent)
    : QObject(parent)
    , m_running(false)
    , m_process(new QProcess(this))
{
    connect(m_process, &QProcess::started, this, [this]() {
        m_running = true;
        emit runningChanged();
    });
    connect(m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, [this]() {
        m_running = false;
        emit runningChanged();
    });

    QSettings settings;
    m_fgRoot = settings.value("fgRoot").toString();
    if (!m_fgRoot.isEmpty()) {
        scanAircraft();
    }
}

void LaunchManager::launch(QStringList args) {
    if (m_running) return;

    // If no arguments were provided (which is okay until launch system is completed), we'll use placehodlers
    if (args.length() == 0)
    {
        args << "--airport=LFPO"
             << "--aircraft=c172p";
    }

    qDebug() << "Warning: No arguments to start with, starting with placeholders: ULLI, c172p!";

    m_process->start("fgfs", args);
}

bool LaunchManager::isValidFgRoot(const QString& path) const
{
    QDir dir(path);
    if (!dir.exists()) {
        return false;
    }

    QFileInfo versionFile(dir.filePath("version"));
    if (!versionFile.exists() || !versionFile.isFile()) {
        return false;
    }

    static const QStringList requiredDirs = {"Aircraft", "Scenery"};
    for (const QString& sub : requiredDirs) {
        if (!QFileInfo::exists(dir.filePath(sub))) {
            return false;
        }
    }

    return true;
}

QString LaunchManager::readFgDataVersion(const QString& path) const
{
    QFile f(QDir(path).filePath("version"));
    if (!f.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return QString();
    }
    QString ver = QString::fromUtf8(f.readAll()).trimmed();
    return ver;
}



bool LaunchManager::setFgRoot(const QString& path) {
    if (!isValidFgRoot(path)) {
        qDebug() << "Invalid fgdata root:" << path;
        return false;
    }

    m_fgRoot = path;
    QSettings settings;
    settings.setValue("fgRoot", m_fgRoot);
    emit fgRootChanged();
    scanAircraft();

    return true;
}

QString LaunchManager::fgRoot() const { return m_fgRoot; }

QStringList LaunchManager::aircraftList() const { return m_aircraftList; }

void LaunchManager::scanAircraft() {
    m_aircraftList.clear();
    QDir aircraftDir(m_fgRoot + "/Aircraft");
    qDebug() << "scanAircraft called, fgRoot =" << m_fgRoot << "exists =" << aircraftDir.exists();
    if (!aircraftDir.exists()) return;
    const auto dirs = aircraftDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QString& name : dirs) {
        QDir sub(aircraftDir.filePath(name));
        const auto setFiles = sub.entryList({"*-main.xml", "*-common.xml"}, QDir::Files);
        if (!setFiles.isEmpty()) {
            m_aircraftList << name;
        }
    }
    qDebug() << "aircraftList =" << m_aircraftList;
    emit aircraftListChanged();
}

QString LaunchManager::aircraftThumbnail(const QString& aircraftName) {
    QString path = m_fgRoot + "/Aircraft/" + aircraftName + "/thumbnail.jpg";
    if (QFileInfo::exists(path)) {
        return "file://" + path;
    }

    return "qrc:/assets/default_aircraft.jpg";
}

QVariantMap LaunchManager::aircraftMetadata(const QString& aircraftName) const
{
    QVariantMap result;
    result["description"] = QString();
    result["author"] = QString();
    result["rating"] = 0;

    QDir dir(m_fgRoot + "/Aircraft/" + aircraftName);
    const auto setFiles = dir.entryList({"*-main.xml", "*-common.xml"}, QDir::Files);
    if (setFiles.isEmpty()) {
        return result;
    }

    QFile file(dir.filePath(setFiles.first()));
    if (!file.open(QIODevice::ReadOnly)) {
        return result;
    }

    QXmlStreamReader xml(&file);
    QStringList path; // текущий путь тегов, чтобы не путать <description> в разных секциях
    int ratingSum = 0;
    int ratingCount = 0;

    while (!xml.atEnd()) {
        xml.readNext();
        if (xml.isStartElement()) {
            path << xml.name().toString();
            const QString tag = xml.name().toString();

            if (path.join("/") == "PropertyList/sim/description") {
                result["description"] = xml.readElementText();
            } else if (path.join("/") == "PropertyList/sim/author") {
                result["author"] = xml.readElementText();
            } else if (path.startsWith("PropertyList") && path.contains("rating") && tag != "rating") {
                bool ok = false;
                int val = xml.readElementText().toInt(&ok);
                if (ok) {
                    ratingSum += val;
                    ratingCount++;
                }
            }
        } else if (xml.isEndElement()) {
            if (!path.isEmpty()) path.removeLast();
        }
    }

    if (ratingCount > 0) {
        result["rating"] = qRound(static_cast<double>(ratingSum) / ratingCount);
    }

    return result;
}

void LaunchManager::stop() {
    if (!m_running) return;
    m_process->terminate();
}

bool LaunchManager::isRunning() const {
    return m_running;
}
