int main(){
	unsigned char a=10;
	
	asm volatile{
		"addi %0,10 \n\t"
		"export "
		:"=r"(a) 
	}
}