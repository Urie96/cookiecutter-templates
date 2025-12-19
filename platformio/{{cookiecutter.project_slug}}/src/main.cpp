#include <Arduino.h>

const int ledPin = 15;

void setup() {
  // 设置引脚为输出模式
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  Serial.println("Hello from Arduino!");
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
}
