#include <stdio.h>

void PrintBits(unsigned int x)
{
	int i;
	for (i = 8 * sizeof(x) - 1; i >= 0; i--)
	{
		(x & (1 << i)) ? putchar('1') : putchar('0');
	}
	printf("\n");
}
void PrintBitsOfByte(unsigned int x)
{
	int i;
	for (i = 7; i >= 0; i--)
	{
		(x & (1 << i)) ? putchar('1') : putchar('0');
	}
	printf("\n");
}

// 1.1
int bitOr(int x, int y)
{
	//PrintBits(x);
	//PrintBits(y);
	return ~(~x & ~y);
}

// 1.2
int negative(int x)
{
	return 0;
}

// 1.3
int getHexcha(int x, int n)
{
	return 0;
}

// 1.4
int flipByte(int x, int n)
{
	return 0;
}

// 1.5
int divpw2(int x, int n)
{
	return 0;
}



// 2.1
int isEqual(int x, int y)
{	
	// Trong phép XOR, nếu hai bit giống nhau thì kết quả là 0, khác nhau thì kết quả là 1. Vậy nên nếu hai số bằng nhau thì kết quả phép XOR sẽ là 0
	int result = x ^ y;

	// Test
	// printf("\n");
	// printf("x = "); PrintBitsOfByte(x);
	// printf("y = "); PrintBitsOfByte(y);
	// printf("x ^ y = "); PrintBitsOfByte(result);
	// printf("return %d\n", ~((result | (~result + 1)) >> 31) & 1);

	/*
    * Giải thích biểu thức trả về:
    * (result | (~result + 1)) >> 31
    *   - Bằng 0 nếu result = 0
    *   - Bằng -1 (tất cả bit = 1) nếu result ≠ 0
    *
    * ~(...) & 1:
    *   - Nếu result = 0 => ~0 & 1 = 1
    *   - Nếu result ≠ 0 => ~(-1) & 1 = 0
    */
	return ~((result | (~result + 1)) >> 31) & 1;
}

// 2.2
int is16x(int x)
{
	/*
	* Một số là bội của 16 thì 4 bit cuối của nó sẽ là 0
	* Vì vậy ta cần AND số đó với mặt nạ 0000 0000 0000 0000 0000 0000 0000 1111 (tương đương với 15 trong hệ thập phân)
	* Nếu kết quả phép AND bằng 0 thì số đó là bội của 16
	*/ 
	int result = x & 15;      
	
	// Test
	// printf("\nx = "); PrintBits(x);
	// printf("x & 15 = "); PrintBitsOfByte(result);
	// printf("return %d\n", ~((result | (~result + 1)) >> 31) & 1);

	/*
    * Biểu thức trả về:
    * (result | (~result + 1)) >> 31
    *   - Bằng 0 nếu result = 0
    *   - Bằng -1 (tất cả bit = 1) nếu result ≠ 0
    *
    * ~(...) & 1:
    *   - Nếu result = 0 → trả về 1
    *   - Nếu result ≠ 0 → trả về 0 
    */
    return ~((result | (~result + 1)) >> 31) & 1;
}

// 2.3
int isPositive(int x)
{
	/*
    * (x | (~x + 1)) >> 31
    *   - Bằng 0 nếu x = 0
    *   - Bằng -1 nếu x ≠ 0
    * Sau đó lấy ~... & 1 để đảo:
    *   - Nếu x = 0 → isZero = 1
    *   - Nếu x ≠ 0 → isZero = 0
    */
	int isZero = ~((x | (~x + 1)) >> 31) & 1;

	// Dịch phải x sang 31 lần để chuyển bit dấu ra ngoài cùng bên phải
	// Sau đó AND với mặt nạ 0000 0000 0000 0000 0000 0000 0000 0001 (tương đương với số 1 trong hệ thập phân)
	// Kết quả sẽ là 0 nếu x là số dương, ngược lại sẽ là 1
	int result = x >> 31 & 1;
	
	// Test
	// printf("\nx = "); PrintBits(x);
	// printf("isZero = "); PrintBitsOfByte(isZero);
	// printf("signBit = "); PrintBitsOfByte(result);
	// printf("return %d\n", (~result & ~isZero) & 1);

	/*
    * Trả về:
    * (~result & ~isZero) & 1
    *   - Nếu x > 0 → trả về 1
    *   - Nếu x ≤ 0 → trả về 0
    */
	return (~result & ~isZero) & 1;
}

// 2.4
int isGE2n(int x, int y)
{
	// Nếu x >= 2^y thì luôn luôn (x >> y) >= 1
	int result = x >> y;

	// Test
	// printf("\n");
	// printf("x = "); PrintBits(x);
	// printf("y = %d\n", y);
	// printf("x >> y = "); PrintBits(result);
	// printf("return %d\n", (result | (~result + 1) >> 31) & 1);

	// Nếu result != 0  => x >= 2^y
	// Nếu result == 0 => x < 2^y
	return (result | (~result + 1) >> 31) & 1;
}

int main()
{

	int score = 0;
	printf("Your evaluation result:");
	printf("\n1.1 bitOr");
	if (bitOr(3, -9) == (3 | -9))
	{
		printf("\tPass.");
		score += 1;
	}
	else
		printf("\tFailed.");

	printf("\n1.2 negative");
	if (negative(0) == 0 && negative(9) == -9 && negative(-5) == 5)
	{
		printf("\tPass.");
		score += 1;
	}
	else
		printf("\tFailed.");

	//1.3
	printf("\n1.3 getHexcha");
	if (getHexcha(26, 0) == 0xa && getHexcha(0x11223344, 1) == 0x4)
	{
		printf("\tPass.");
		score += 2;
	}
	else
		printf("\tFailed.");

	printf("\n1.4 flipByte");
	if (flipByte(10, 0) == 245 && flipByte(0, 1) == 65280 && flipByte(0x5501, 1) == 0xaa01)
	{
		printf("\tPass.");
		score += 3;
	}
	else
		printf("\tFailed.");
	//1.5
	printf("\n1.5 divpw2");
	if (divpw2(10, -1) == 20 && divpw2(15, -2) == 60 && divpw2(2, -4) == 32)
	{
		if (divpw2(10, 1) == 5 && divpw2(50, 2) == 12)
		{
			printf("\tAdvanced Pass.");
			score += 4;
		}
		else
		{
			printf("\tPass.");
			score += 3;
		}
	}
	else
		printf("\tFailed.");

	printf("\n2.1 isEqual");
	if (isEqual(4, 2) == 0 && isEqual(-4, -4) == 1 && isEqual(0, 10) == 0)
	{
		printf("\tPass.");
		score += 2;
	}
	else
		printf("\tFailed.");

	//2.2
    // 
	printf("\n2.2 is16x");
	if (is16x(16) == 1 && is16x(23) == 0 && is16x(0) == 1)
	{
		printf("\tPass.");
		score += 2;
	}
	else
		printf("\tFailed.");

	printf("\n2.3 isPositive");
	if (isPositive(10) == 1 && isPositive(-5) == 0 && isPositive(0) == 0)
	{
		printf("\tPass.");
		score += 3;
	}
	else
		printf("\tFailed.");


	//2.4
	printf("\n2.4 isGE2n");
	if (isGE2n(12, 4) == 0 && isGE2n(8, 3) == 1 && isGE2n(15, 2) == 1)
	{
		printf("\tPass.");
		score += 3;
	}
	else
		printf("\tFailed.");

	printf("\n--- FINAL RESULT ---");
	printf("\nScore: %.1f", (float)score / 2);
	if (score < 5)
		printf("\nTrouble when solving these problems? Contact your instructor to get some hints :)");
	else
	{
		if (score < 8)
			printf("\nNice work. But try harder.");
		else
		{
			if (score >= 10)
				printf("\nExcellent. We found a master in bit-wise operations :D");
			else
				printf("\nYou're almost there. Think more carefully in failed problems.");
		}
	}

	printf("\n\n\n");
}