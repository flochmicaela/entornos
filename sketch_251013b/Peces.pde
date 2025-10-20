class Pez {
  int id;             
  float x, y;         // posición actual
  float ySoga;        // altura de la soga
  float largo;        // largo del pez
  float alto;         // alto del pez
  
  boolean colgado = true;

  Pez(int id_, float x_, float y_, float ySoga_) {
    id = id_;
    x = x_;
    y = y_;
    ySoga = ySoga_;
    
    // Tamaños relativos al alto de la pantalla
    largo = height * 0.06;
    alto = height * 0.03;
  }

  void actualizar(Pincel p) {
    if (colgado) {
      float d = dist(x, y, p.x, p.y);
      if (d < height * 0.04) { // radio de detección proporcional
        colgado = false; 
        enviarEstadoAUnity();
      }
    }
  }

  void dibujar() {
    // Línea que lo cuelga
    stroke(80);
    line(x, ySoga, x, y - largo / 2);

    // Cuerpo del pez
    noStroke();
    fill(10, 150, 200);
    ellipse(x, y, alto, largo);

    // Triángulo decorativo
    fill(0);
    float triOffset = height * 0.02; // proporcional también
    triangle(x - alto / 2, y - largo / 2 - triOffset,
             x + alto / 2, y - largo / 2 - triOffset,
             x, y - largo / 2);
  }

  void enviarEstadoAUnity() {
    OscMessage msg = new OscMessage("/pez");
    msg.add(id);
    msg.add(x);
    msg.add(y);
    msg.add(colgado ? 1 : 0);
    oscP5.send(msg, unityAddr);
  }
}
