import oscP5.*;
import netP5.*;
import java.util.ArrayList;

// --- OSC ---
int PUERTO = 12345;
Receptor receptor;
Pincel pincel;

// --- Cuadros y objetos (se calculan dinámicamente) ---
float FLORES_X, FLORES_Y, FLORES_W, FLORES_H;
float FRUTAS_X, FRUTAS_Y, FRUTAS_W, FRUTAS_H;
float PECES_X, PECES_Y, PECES_W, PECES_H;

ArrayList<Fruta> frutas;
ArrayList<Flor> flores;
ArrayList<Pez> peces;

void setup() {
  fullScreen(); // Usar pantalla completa

  // --- calcular dimensiones proporcionales ---
  FLORES_X = width * 0.05;
  FLORES_Y = height * 0.2;
  FLORES_W = width * 0.2;
  FLORES_H = height * 0.6;

  PECES_X = width * 0.3;
  PECES_Y = height * 0.08;
  PECES_W = width * 0.4;
  PECES_H = height * 0.2;

  FRUTAS_X = width * 0.75;
  FRUTAS_Y = height * 0.2;
  FRUTAS_W = width * 0.2;
  FRUTAS_H = height * 0.6;
  
  // Inicializar OSC
  setupOSC(PUERTO);
  setupUnityOSC(); 
  receptor = new Receptor();
  pincel = new Pincel();

  frutas = new ArrayList<Fruta>();
  flores = new ArrayList<Flor>();
  peces = new ArrayList<Pez>();

  // Inicializar todos los objetos (se vuelve a llamar en draw por si se ajusta el tamaño)
  initObjetos();
}

void draw() {
  background(255);

  // --- calcular dimensiones proporcionales ---
  FLORES_X = width * 0.05;
  FLORES_Y = height * 0.2;
  FLORES_W = width * 0.2;
  FLORES_H = height * 0.6;

  PECES_X = width * 0.3;
  PECES_Y = height * 0.08;
  PECES_W = width * 0.4;
  PECES_H = height * 0.2;

  FRUTAS_X = width * 0.75;
  FRUTAS_Y = height * 0.2;
  FRUTAS_W = width * 0.2;
  FRUTAS_H = height * 0.6;

  // --- dibujar cuadros ---
  noFill();
  stroke(180);
  strokeWeight(3);
  rect(FLORES_X, FLORES_Y, FLORES_W, FLORES_H);
  rect(PECES_X, PECES_Y, PECES_W, PECES_H);
  rect(FRUTAS_X, FRUTAS_Y, FRUTAS_W, FRUTAS_H);

  receptor.actualizar();

  // actualizar pincel si hay blob
  Blob blobPincel = detectarLAPIZ(receptor.blobsIn);
  if (blobPincel != null) pincel.actualizarDesdeBlob(blobPincel);
  pincel.dibujar();

  // actualizar y dibujar frutas
  for (Fruta f : frutas) f.actualizar(pincel);
  for (Fruta f : frutas) f.dibujar();

  // actualizar y dibujar flores
  for (Flor f : flores) f.actualizar(pincel);
  for (Flor f : flores) f.dibujar();

  // dibujar soga (usando proporciones)
  noFill();
  stroke(80);
  strokeWeight(3);
  beginShape();
  for (float x = PECES_X; x <= PECES_X + PECES_W; x += 20) {
    float y = PECES_Y + sin(map(x, PECES_X, PECES_X + PECES_W, 0, PI)) * (height * 0.02);
    vertex(x, y);
  }
  endShape();

  // actualizar y dibujar peces
  for (Pez p : peces) p.actualizar(pincel);
  for (Pez p : peces) p.dibujar();

  receptor.dibujarBlobs(width, height);

  // enviar datos a Unity
  enviarPecesAUnity();
  enviarFloresAUnity();
  enviarFrutasAUnity();
}

// --- Inicialización de objetos ---
void initObjetos() {
  frutas.clear();
  frutas.add(new Fruta(0, FRUTAS_X + FRUTAS_W / 2, FRUTAS_Y + FRUTAS_H * 0.7));
  frutas.add(new Fruta(1, FRUTAS_X + FRUTAS_W / 2, FRUTAS_Y + FRUTAS_H * 0.5));
  frutas.add(new Fruta(2, FRUTAS_X + FRUTAS_W / 2, FRUTAS_Y + FRUTAS_H * 0.3));

  flores.clear();
  for (int i = 0; i < 4; i++) {
    float fx = FLORES_X + FLORES_W / 2;
    float spacing = FLORES_H / 5;
    float fy = FLORES_Y + spacing + i * spacing;
    flores.add(new Flor(i, fx, fy));
  }

  peces.clear();
  float margen = width * 0.01;
  float inicioX = PECES_X + margen;
  float finX = PECES_X + PECES_W - margen;
  float baseY = PECES_Y;

  for (int i = 0; i < 9; i++) {
    float x = map(i, 0, 8, inicioX, finX);
    float ySoga = baseY + sin(map(i, 0, 8, 0, PI)) * (height * 0.02);
    float yPez = ySoga + height * 0.06;
    peces.add(new Pez(i, x, yPez, ySoga));
  }
}

// --- Detección de lápiz ---
Blob detectarLAPIZ(ArrayList<Blob> blobs) {
  Blob mejor = null;
  float maxArea = -1;

  for (Blob b : blobs) {
    if (b != null && !b.salio && b.area > maxArea) {
      mejor = b;
      maxArea = b.area;
    }
  }
  return mejor;
}
