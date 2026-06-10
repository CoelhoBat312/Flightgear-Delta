#ifndef LAUNCHMANAGER_H
#define LAUNCHMANAGER_H

#include <QObject>
#include <QProcess>
#include <QStringList>

class LaunchManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(QString fgRoot READ fgRoot WRITE setFgRoot NOTIFY fgRootChanged)
    Q_PROPERTY(QStringList aircraftList READ aircraftList NOTIFY aircraftListChanged)

public:
    explicit LaunchManager(QObject* parent = nullptr);

    Q_INVOKABLE void launch();
    Q_INVOKABLE void stop();
    Q_INVOKABLE QString aircraftThumbnail(const QString& aircraftName);

    bool isRunning() const;
    QString fgRoot() const;
    QStringList aircraftList() const;
    void setFgRoot(const QString& path);

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
