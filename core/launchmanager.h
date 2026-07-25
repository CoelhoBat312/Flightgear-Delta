#ifndef LAUNCHMANAGER_H
#define LAUNCHMANAGER_H

#include <QObject>
#include <QProcess>
#include <QStringList>
#include <QSettings>

class LaunchManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(QString fgRoot READ fgRoot WRITE setFgRoot NOTIFY fgRootChanged)
    Q_PROPERTY(QStringList aircraftList READ aircraftList NOTIFY aircraftListChanged)

public:
    explicit LaunchManager(QObject* parent = nullptr);

    // Invokables
    // Launch and stop
    Q_INVOKABLE void launch(QStringList args);
    Q_INVOKABLE void stop();

    // Others
    Q_INVOKABLE QString aircraftThumbnail(const QString& aircraftName);
    Q_INVOKABLE bool setFgRoot(const QString& path);
    Q_INVOKABLE bool isValidFgRoot(const QString& path) const;
    Q_INVOKABLE QString readFgDataVersion(const QString& path) const;
    Q_INVOKABLE QVariantMap aircraftMetadata(const QString& aircraftName) const;


    bool isRunning() const;
    QString fgRoot() const;
    QStringList aircraftList() const;

signals:
    void runningChanged();
    void fgRootChanged();
    void aircraftListChanged();

private:
    bool m_running = false;
    QProcess* m_process;
    QString m_fgRoot;
    QStringList m_aircraftList;
    void scanAircraft();
};

#endif // LAUNCHMANAGER_H
