# 🟩 Mobile Box Task

**Kurzfassung**: Box Task in der mobilen Umsetzung.

Box Task ist eine Evaluationsmethode für die Messung der Ablenkung von In-Vehicle Information Systems (Displays) beim Fahren. Die Hauptaufgabe (Fahren) wird durch eine alternative Aufgabe ersetzt, bei der eine Box zwischen zwei Rahmen gehalten wird. Die Box ändert ihre Größe und Position in Abhängigkeit der Beschleunigung und Lenkung des Nutzenden.

**Reference**: [Link zum Artikel](https://www.sciencedirect.com/science/article/pii/S2215016121000546)

## 🕍 Tech

### Hauptskills
Flutter, Javascript, Node.js, Express, socket.io

Es gibt drei Anwendungen: App (Flutter), Webbrowser (Javascript) und Server (Node.js). Die Darstellungen auf dem Handy und Monitoren laufen synchron.

#### Server (Node.js)
- Verarbeitung von gemessenen Daten und Weiterleitung an die Webseite und App 
- Echtzeitkommunikation mittels socket.io

#### App (Flutter)
- Direkte Messung und Größenbestimmung der Box
- Weiterleitung von Daten an den Server
    
<img src="https://github.com/Rhaun95/Mobile-Box-Task/assets/105895293/99586c1e-52f5-4464-acdf-36aa562d6ba3" alt="App Screenshot" width="450" height="220">

#### Webbrowser (Javascript)
- Darstellung von Daten
  
<img src="https://github.com/Rhaun95/Mobile-Box-Task/assets/105895293/b6a8f38f-9980-4919-8c2f-a6689a838dd4" alt="Webbrowser Screenshot" width="800" height="400">
