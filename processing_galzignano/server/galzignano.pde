import processing.sound.*;
import websockets.*;
import java.util.ArrayList;
import java.util.HashMap;

WebsocketServer ws;
PImage img;
int x, y;
HashMap<String, SoundFile> suoniAmbiente = new HashMap<String, SoundFile>(); // Mappa per i suoni ambientali
ArrayList<SoundFile> suoniUccelliInRiproduzione = new ArrayList<SoundFile>(); // Elenco dei suoni degli uccelli in riproduzione

void setup() {
  size(1920, 1080);
  ws = new WebsocketServer(this, 8025, "/john"); // Inizializzo il server WebSocket
  x = 0;
  y = 0;

  // Inizializzo i suoni ambientali per gli habitat
  String[] habitat = {"Antropici", "Boschivi", "Pianure", "Prativi", "Rocciosi", "Umidi"};
  for (String h : habitat) {
    String soundPath = dataPath(h + ".wav"); // Percorso al file audio dell'habitat
    SoundFile suonoAmbiente = new SoundFile(this, soundPath);
    suoniAmbiente.put(h, suonoAmbiente); // Aggiunge il suono ambiente alla mappa
  }
}

void draw() {
  background(0);
  if (img != null) {
    img.resize(1920, 1080);  // Ridimensiona l'immagine alle dimensioni del proiettore
    image(img, x, y); // Se c'è un'immagine, la mostro
  }
}

void webSocketServerEvent(String msg) {
  println("Messaggio ricevuto dal client: " + msg); // Stampa il messaggio ricevuto dal client
  if (msg.equalsIgnoreCase("stop")) {
    // Se il messaggio è "stop", si cancella il disegno, si rimuove l'immagine e si fermano tutti i suoni 
    // ambientali e degli uccelli in riproduzione
    img = null; 
    for (SoundFile suonoAmbiente : suoniAmbiente.values()) {
      suonoAmbiente.stop();
    }
    for (SoundFile suono : suoniUccelliInRiproduzione) {
      suono.stop(); 
    }
    suoniUccelliInRiproduzione.clear(); // Svuoto l'elenco dei suoni degli uccelli
  } else if (suoniAmbiente.containsKey(msg)) {
    // Se il messaggio corrisponde a un habitat, si carica e mostra l'immagine corrispondente, 
    // si fermano tutti i suoni degli uccelli e si avvia il suono ambiente specifico
    String imagePath = dataPath(msg + ".png");
    img = loadImage(imagePath);
    x = 0;
    y = 0;
    
    for (SoundFile suono : suoniUccelliInRiproduzione) {
      suono.stop();
    } 
    suoniUccelliInRiproduzione.clear();
    
    for (SoundFile suono : suoniAmbiente.values()) {
      suono.stop();
    }  
    suoniAmbiente.get(msg).play(); // Avvio il suono ambiente specifico per l'habitat selezionato 
    
  } else {
    // Altrimenti, si carica e si riproduce il suono degli uccelli e si tiene traccia dei suoni in riproduzione
    String soundPath = dataPath(msg + ".wav");
    SoundFile suono = new SoundFile(this, soundPath);
    suono.play();
    suoniUccelliInRiproduzione.add(suono); 
  }
}
