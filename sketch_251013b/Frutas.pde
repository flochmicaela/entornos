class Fruta {
  int id;
  float x, y;
  float radio;
  int toques = 0;
  boolean cayendo = false;

  Fruta(int id_, float x_, float y_) {
    id = id_;
    x = x_;
    y = y_;
    
    // Tamaño relativo al alto de la pantalla
    radio = height * 0.04; // por ejemplo, 4% del alto
  }

  void actualizar(Pincel pincel) {
    float d = dist(pincel.x, pincel.y, x, y);

    if (!cayendo && d < radio) {
      toques++;
      enviarEstadoAUnity();

      if (toques >= 3) {
        cayendo = true;
      }
    }
  }

  void dibujar() {
    fill(255, 100, 0); // naranja tipo fruta
    stroke(0);
    ellipse(x, y, radio * 2, radio * 2);
  }

  void enviarEstadoAUnity() {
    OscMessage msg = new OscMessage("/fruta");
    msg.add(id);
    msg.add(x);
    msg.add(y);
    msg.add(toques);
    msg.add(cayendo ? 1 : 0);
    oscP5.send(msg, unityAddr);
  }
}
