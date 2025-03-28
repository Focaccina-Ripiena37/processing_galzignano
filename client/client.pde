import websockets.*;

WebsocketClient client;
String inputText="";

void setup() {
  size(200, 200);
  client = new WebsocketClient(this, "ws://localhost:8025/john");
}

void draw() {
  background(220);
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(0);
  text(inputText, width / 2, height / 2);
}

void keyPressed() {
  if (key >= '0' && key <= '9') {
    // Se il tasto premuto è un numero, aggiungilo all'inputText
    inputText += key;
  } else if (key == '\n') {
    // Se il tasto premuto è "Invio", invia il messaggio corrispondente al server
    if (!inputText.isEmpty()) {
      String message = getCustomMessage(inputText);
      client.sendMessage(message);
      inputText = ""; // Reset dell'inputText
    }
  } else if (key == 'c' || key == 'C') {
    client.sendMessage("stop");
  }
}

// Il client deve adottare uno standard per scrivere i nomi nei messaggi che invia al server
String getCustomMessage(String input) {
  // Assegna un messaggio diverso in base all'input numerico
  switch (input) {
    case "0":
      return "Alzavola"; // Umido
    case "1":
      return "Averla-piccola"; // Prativo
    case "2":
      return "Storno"; // Antropico
    case "3":
      return "Poiana"; // Roccioso + Coltivato
    case "4":
      return "Gazza"; // Prativo + Antropico
    case "5":
      return "Ghiandaia"; // Boschivo
    case "6":
      return "Antropici"; 
    case "7":
      return "Boschivi"; 
    case "8":
      return "Prativi"; 
    case "9":
      return "Pianure";
    case "10":
      return "Rocciosi";
    case "11":
      return "Umidi";
    default:
      return "Non e' stato selezionato nessun ambiente o uccello";
  }
}

void onMessage(String message) {
  println("Messaggio ricevuto dal server: " + message);
}
