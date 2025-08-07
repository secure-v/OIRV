int main() {
	char str[] = "\033[38;2;199;125;147mHello World!\n\033[0m";

    for (int i = 0; i < sizeof(str);i++) {
        *(char*)0x10000000 = str[i];
    }

	return *(int*)(str);
}
