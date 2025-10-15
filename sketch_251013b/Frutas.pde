class Fruta {
  int id;
  float x, y;
  float radio = 40;
  boolean cayendo = false;
  float vy = 0;
  int toques = 0;

  Fruta(int id_, float x_, float y_) {
    id = id_;
    x = x_;
    y = y_;
  }

  void actualizar(Pincel pincel) {
    float d = dist(pincel.x, pincel.y, x, y);

    if (!cayendo && d < radio) {
      toques++;
      if (toques >= 10) {
        cayendo = true;
      } else {
        // Temblor aleatorio
        x += random(-2, 2);
        y += random(-2, 2);
      }
    }

    if (cayendo) {
      vy += 0.5;  // gravedad
      y += vy;

      // Rebotar si toca el suelo
      if (y + radio > height) {
        y = height - radio;
        vy *= -0.6;

        // si rebote es muy débil, lo detenemos
        if (abs(vy) < 1) {
          vy = 0;
        }
      }
    }
  }

  void dibujar() {
    fill(255, 100, 0); // naranja / tipo fruta
    stroke(0);
    ellipse(x, y, radio * 2, radio * 2);
  }
}
