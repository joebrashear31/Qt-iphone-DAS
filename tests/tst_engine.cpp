#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSignalSpy>
#include <QtTest/QtTest>

// Smoke test: verifies that the QQmlApplicationEngine can load main.qml
// without emitting objectCreationFailed.
// RED: will fail if the QML URI is wrong or main.qml has a syntax error.
class EngineTest : public QObject
{
    Q_OBJECT

private slots:
    void test_mainQmlLoadsWithoutError()
    {
        QQmlApplicationEngine engine;

        // Spy on the failure signal BEFORE loading
        QSignalSpy failSpy(&engine,
                           &QQmlApplicationEngine::objectCreationFailed);

        // URI matches qt_add_qml_module(tst_engine URI SenseCaptureEngine ...) in tests/CMakeLists.txt
        engine.load(QUrl(u"qrc:/SenseCaptureEngine/main.qml"_qs));

        // Give the event loop a moment to process async signals
        QTest::qWait(200);

        QCOMPARE(failSpy.count(), 0);
        QVERIFY2(!engine.rootObjects().isEmpty(),
                 "Root object should be created after loading main.qml");
    }
};

// QTest requires a QGuiApplication for QML rendering
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    EngineTest test;
    return QTest::qExec(&test, argc, argv);
}

#include "tst_engine.moc"
