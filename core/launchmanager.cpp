#include "launchmanager.h"
#include <QProcess>
#include <QDir>
#include <QFileInfo>

LaunchManager::LaunchManager(QObject* parent)
    : QObject(parent)
    , m_running(false)
    , m_process(new QProcess(this))
{
    connect(m_process, &QProcess::started, this, [this]() {
        m_running = true;
        emit runningChanged();
    });

    connect(m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        this, [this]() {
            m_running = false;
            emit runningChanged();
        });
}

void LaunchManager::launch() {
    if (m_running) return;

    QStringList args;
    args << "--airport=>ULLI"
         << "--aircraft=c172p"
         << "--time-of-day=noon";

    m_process->start("fgfs", args);
}

void LaunchManager::setFgRoot(const QString& path) {
    m_fgRoot = path;
    emit fgRootChanged();
    scanAircraft();
}

QString LaunchManager::fgRoot() const { return m_fgRoot; }

QStringList LaunchManager::aircraftList() const { return m_aircraftList; }

void LaunchManager::scanAircraft() {
    m_aircraftList.clear();

    QDir aircraftDir(m_fgRoot + "/Aircraft");
    if (!aircraftDir.exists()) return;

    const auto dirs = aircraftDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QString& name : dirs) {
        QDir sub(aircraftDir.filePath(name));
        const auto setFiles = sub.entryList({"*-set.xml"}, QDir::Files);
        if (!setFiles.isEmpty()) {
            m_aircraftList << name;
        }
    }

    emit aircraftListChanged();
}

QString LaunchManager::aircraftThumbnail(const QString& aircraftName) {
    QString path = m_fgRoot + "/Aircraft/" + aircraftName + "/thumbnail.jpg";
    if (QFileInfo::exists(path)) {
        return "file://" + path;
    }

    return "qrc:/images/default_aircraft.jpg";
}

void LaunchManager::stop() {
    if (!m_running) return;
    m_process->terminate();
}

bool LaunchManager::isRunning() const {
    return m_running;
}
