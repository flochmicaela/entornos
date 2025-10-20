class PetaloFlor {
  float x, y;    // posición del pétalo
  float angulo;  // ángulo relativo al centro, útil para dibujarlo
  
  PetaloFlor(float x_, float y_, float angulo_) {
    x = x_;
    y = y_;
    angulo = angulo_;
  }

  void dibujar() {
    pushMatrix();
    translate(x, y);
    rotate(angulo);
    stroke(0);
    noFill();
    ellipse(0, 0, 20, 40); // dibujo simple del pétalo
    popMatrix();
  }
}


class Flor {
  int id;  
  float x, y;
  float radioCentro;
  int totalPetalos = 8;
  ArrayList<PetaloFlor> misPetalos;
  
  int petalosTocados = 0; 
  int petalosRestantes; // Para enviar a Unity
  
  Flor(int id_, float x_, float y_) {
    id = id_;
    x = x_;
    y = y_;
    
    // Radio del centro relativo al alto
    radioCentro = height * 0.02;
    
    misPetalos = new ArrayList<PetaloFlor>();

    // crear pétalos alrededor del centro
    float radioPetalos = height * 0.05; // distancia del centro a los pétalos
    for (int i = 0; i < totalPetalos; i++) {
      float ang = TWO_PI / totalPetalos * i;
      float px = x + cos(ang) * radioPetalos;
      float py = y + sin(ang) * radioPetalos;
      misPetalos.add(new PetaloFlor(px, py, ang));
    }
    petalosRestantes = totalPetalos; // Inicializar
  }

  void actualizar(Pincel pincel) {
    // Resetear el contador de toques para este frame
    petalosTocados = 0;

    for (int i = misPetalos.size() - 1; i >= 0; i--) {
      PetaloFlor pf = misPetalos.get(i);
      float d = dist(pincel.x, pincel.y, pf.x, pf.y);

      if (d < height * 0.025) { // Si hay detección (el blob está tocando el pétalo)

        petalosTocados++; // Incrementamos el contador de toques para este frame
      }
    }
    
    // Si al menos un pétalo fue tocado, enviamos un mensaje a Unity
    if (petalosTocados > 0) {
    }
    
  }

  void dibujar() {
    for (PetaloFlor pf : misPetalos) pf.dibujar();
    fill(255, 220, 0);
    stroke(0);
    ellipse(x, y, radioCentro * 2, radioCentro * 2);
  }

  void enviarAUnity() {
   
    OscMessage msg = new OscMessage("/flor");
    msg.add(id);
    msg.add(x);
    msg.add(y);

    msg.add(petalosTocados); // Envía cuántos pétalos el pincel está tocando actualmente 
    oscP5.send(msg, unityAddr);
    

  }
}
