import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress unityAddr;

void setupUnityOSC() {
  oscP5 = new OscP5(this, 12345); // puerto local (puede ser diferente)
  unityAddr = new NetAddress("127.0.0.1", 9000); // puerto de Unity
}

// Enviar datos de peces
void enviarPecesAUnity() {
  for (int i = 0; i < peces.size(); i++) {
    Pez p = peces.get(i);
    OscMessage msg = new OscMessage("/pez");
    msg.add(i);                 // id
    msg.add(p.x);               // posición x
    msg.add(p.y);               // posición y
    msg.add(p.colgado ? 1 : 0); // estado colgado
    oscP5.send(msg, unityAddr);
  }
}
  void enviarFloresAUnity() {
    for (int i = 0; i < flores.size(); i++) {
        Flor f = flores.get(i);
        OscMessage msg = new OscMessage("/flor");
        msg.add(i);
        msg.add(f.x);
        msg.add(f.y);
        oscP5.send(msg, unityAddr);
    }
}

void enviarFrutasAUnity() {
    for (int i = 0; i < frutas.size(); i++) {
        Fruta f = frutas.get(i);
        OscMessage msg = new OscMessage("/fruta");
        msg.add(i);
        msg.add(f.x);
        msg.add(f.y);
        oscP5.send(msg, unityAddr);
    }
}
