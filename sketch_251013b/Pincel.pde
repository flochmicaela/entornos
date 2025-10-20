class Pincel {
  float x, y;
  float radio;

  ArrayList<PincelManchaParte> rastroPintura;
  int maxPuntosRastro = 50; 
  float radioBaseMancha; 
  Pincel() {
    rastroPintura = new ArrayList<PincelManchaParte>();
    radioBaseMancha = height * 0.015; 
  }

  void actualizarDesdeBlob(Blob b) {
    float prevX = x; 
    float prevY = y;
    
    x = b.centerX * width;
    y = b.centerY * height;
    
    radio = height * 0.015; /

    if (dist(x, y, prevX, prevY) > radio * 0.2) { 
 
        if (rastroPintura.size() >= maxPuntosRastro) {
            rastroPintura.remove(0); 
        }

        float rastroRadio = radioBaseMancha * random(0.8, 1.2); 
        rastroPintura.add(new PincelManchaParte(x, y, rastroRadio, color(255, 0, 200, 150))); 
    }
  }

  void dibujar() {
    noStroke();
    

    for (int i = 0; i < rastroPintura.size(); i++) {
      PincelManchaParte pm = rastroPintura.get(i);
      

      float currentRadio = pm.radio * (i + 1) / (float)maxPuntosRastro;
      int alpha = (int)map(i, 0, maxPuntosRastro, 30, 180); 
      
      fill(red(pm.c), green(pm.c), blue(pm.c), alpha);
      

      ellipse(pm.x + random(-currentRadio*0.1, currentRadio*0.1), 
              pm.y + random(-currentRadio*0.1, currentRadio*0.1), 
              currentRadio * 2 * random(0.9, 1.1), 
              currentRadio * 2 * random(0.9, 1.1));
    }
    

    fill(255, 0, 200, 255); 
    ellipse(x, y, radio * 1.8, radio * 1.8); 
  }
}


class PincelManchaParte {
  float x, y, radio;
  int c; 

  PincelManchaParte(float x_, float y_, float r_, int col_) {
    x = x_;
    y = y_;
    radio = r_;
    c = col_;
  }
}
