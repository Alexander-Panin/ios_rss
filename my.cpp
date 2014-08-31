#include "iostream"

int gcd(int m, int n) {
  while(n != 0) {
    int r = m % n;
    m = n;
    n = r;
  }
  return m;
}

int main() {
  std::cout << gcd(44,8) << std::endl;
}
