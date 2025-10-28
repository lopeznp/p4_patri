import processing.pdf.*;

PFont myfont;
String onomatopeya = "guau";

int numPelotas = 6; 
GuauPelota[] pelotas; 

void setup() {
  size(595, 879, PDF, "paseo.pdf"); 
  myfont = createFont("B.S.-Mono-Regular.otf", 10);
  textFont(myfont);
  textAlign(CENTER, CENTER);
  background(255);
  fill(0);

  
  pelotas = new GuauPelota[numPelotas];
  for (int i = 0; i < numPelotas; i++) {
    pelotas[i] = new GuauPelota(
      random(width),              // posición inicial X
      random(height),             // posición inicial Y
      random(15, 30),             // tamaño (radio)
      random(0.02, 0.05),         // velocidad de rotación
      random(1, 2.5),             // velocidad de movimiento
      random(TWO_PI)              // dirección inicial
    );
  }
}

void draw() {
  background(255);

  // --------- Paseos ---------
  drawPaseo(width/2 - 150, 17, 30, 1, 1);
  drawPaseo(width/2 - 50, 15, 25, 1, 1.2);
  drawPaseo(width/2 + 50, 20, 35, -1, 0.8); 
  drawPaseo(width/2 + 150, 12, 20, 1, 1.5);
  drawPaseo(width/2, 18, 28, -1, 1); 

  // --------- Dibujar las pelotas ---------
  for (int i = 0; i < numPelotas; i++) {
    pelotas[i].mover();
    pelotas[i].dibujar();
  }
  
PGraphicsPDF pdf = (PGraphicsPDF) g;
  if (frameCount % 30 == 0 && frameCount <= 450) { // 15 páginas (cada 30 frames)
    pdf.nextPage();
    println("Página exportada: " + frameCount/30);
  }

  if (frameCount > 450) { // Detener tras 15 páginas
    println("Exportación finalizada");
    exit();
  }
}

// --------- CLASE "PELOTA GUAU" ---------
class GuauPelota {
  float x, y;
  float radio;
  float velRot;
  float velMov;
  float direccion;
  int repeticiones = 10;

  GuauPelota(float x_, float y_, float radio_, float velRot_, float velMov_, float direccion_) {
    x = x_;
    y = y_;
    radio = radio_;
    velRot = velRot_;
    velMov = velMov_;
    direccion = direccion_;
  }

  void mover() {
    // Movimiento tipo rebote
    x += cos(direccion) * velMov;
    y += sin(direccion) * velMov;

    // Rebote en los bordes
    if (x < radio*2 || x > width - radio*2) {
      direccion = PI - direccion;
    }
    if (y < radio*2 || y > height - radio*2) {
      direccion = -direccion;
    }

    // Movimiento sutil oscilante
    x += sin(frameCount * 0.01 + y * 0.01);
  }

  void dibujar() {
    float anguloBase = frameCount * velRot;

    for (int i = 0; i < repeticiones; i++) {
      float angulo = map(i, 0, repeticiones, 0, TWO_PI) + anguloBase;
      float px = x + cos(angulo) * radio;
      float py = y + sin(angulo) * radio;

      pushMatrix();
      translate(px, py);
      rotate(angulo + HALF_PI);
      text(onomatopeya, 0, 0);
      popMatrix();
    }
  }
}

// --------- FUNCIÓN PASEOS ---------
void drawPaseo(float baseX, int pasos, int velocidad, int direccion, float offsetFactor) {
  int pasoActual = int(frameCount / velocidad) % pasos;
  for (int i = 0; i <= pasoActual; i++) {
    float alpha = (i == pasoActual) ? map(frameCount % velocidad, 0, velocidad, 0, 255) : 255;
    fill(0, alpha);
    
    float y = (direccion == 1) ? height - i * (height / pasos) : i * (height / pasos);
    float x = baseX + sin(frameCount * 0.05 + i) * 15 * offsetFactor;
    
    text(onomatopeya, x, y);
  }
  
  // efecto viento a los lados
  for (int y = 0; y < height; y += 10) {
    float viento = sin(frameCount * 0.05 + y * 0.1) * 15;
    fill(0, 120);
    text(onomatopeya, 30 + viento, y);
    text(onomatopeya, width - 30 + viento, y);
  }
}
