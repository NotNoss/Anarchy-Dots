pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

NotificationServer {
    id: server
    actionsSupported: true
    bodySupported: true
    imageSupported: true

    // Flat, newest-first source of truth.
    property ListModel model: ListModel {}

    // Derived, grouped-by-app view rebuilt on every change.
    // [ { appName, count, urgency, latest: {...}, items: [ {summary, body, time, uid, urgency}, ... ] } ]
    property var groups: []

    property int nextUid: 1

    onNotification: n => {
        model.insert(0, {
            uid: nextUid++,
            summary: n.summary,
            body: n.body,
            appName: n.appName,
            urgency: n.urgency,
            time: Qt.formatDateTime(new Date(), "h:mm ap")
        })
        n.tracked = true
        rebuildGroups()
    }

    function rebuildGroups() {
        const byApp = ({})
        const ordered = []
        for (let i = 0; i < model.count; i++) {
            const row = model.get(i)
            const item = {
                uid: row.uid,
                summary: row.summary,
                body: row.body,
                time: row.time,
                urgency: row.urgency
            }
            let g = byApp[row.appName]
            if (g === undefined) {
                g = {
                    appName: row.appName,
                    count: 0,
                    urgency: row.urgency,
                    latest: item,
                    items: []
                }
                byApp[row.appName] = g
                ordered.push(g)
            }
            g.items.push(item)
            g.count++
            if (row.urgency > g.urgency)
                g.urgency = row.urgency
        }
        groups = ordered
    }

    function removeByUid(uid) {
        for (let i = 0; i < model.count; i++) {
            if (model.get(i).uid === uid) {
                model.remove(i)
                break
            }
        }
        rebuildGroups()
    }

    function removeApp(appName) {
        for (let i = model.count - 1; i >= 0; i--) {
            if (model.get(i).appName === appName)
                model.remove(i)
        }
        rebuildGroups()
    }

    function clearAll() {
        model.clear()
        groups = []
    }
}
