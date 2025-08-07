int main() {
	float a = 5.322;
	float b = -546.8;
	float c = a / b;
	c /= a;
	c /= a;

	b /= a;
	return *(int*)(&b);
}
