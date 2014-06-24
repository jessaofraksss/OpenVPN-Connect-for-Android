#include "arm_arch.h"
#ifdef __ARMEL__
# define LO 0
# define HI 4
# define WORD64(hi0,lo0,hi1,lo1)	.word	lo0,hi0, lo1,hi1
#else
# define HI 0
# define LO 4
# define WORD64(hi0,lo0,hi1,lo1)	.word	hi0,lo0, hi1,lo1
#endif

.text
.code	32
.type	K512,%object
.align	5
K512:
WORD64(0x428a2f98,0xd728ae22, 0x71374491,0x23ef65cd)
WORD64(0xb5c0fbcf,0xec4d3b2f, 0xe9b5dba5,0x8189dbbc)
WORD64(0x3956c25b,0xf348b538, 0x59f111f1,0xb605d019)
WORD64(0x923f82a4,0xaf194f9b, 0xab1c5ed5,0xda6d8118)
WORD64(0xd807aa98,0xa3030242, 0x12835b01,0x45706fbe)
WORD64(0x243185be,0x4ee4b28c, 0x550c7dc3,0xd5ffb4e2)
WORD64(0x72be5d74,0xf27b896f, 0x80deb1fe,0x3b1696b1)
WORD64(0x9bdc06a7,0x25c71235, 0xc19bf174,0xcf692694)
WORD64(0xe49b69c1,0x9ef14ad2, 0xefbe4786,0x384f25e3)
WORD64(0x0fc19dc6,0x8b8cd5b5, 0x240ca1cc,0x77ac9c65)
WORD64(0x2de92c6f,0x592b0275, 0x4a7484aa,0x6ea6e483)
WORD64(0x5cb0a9dc,0xbd41fbd4, 0x76f988da,0x831153b5)
WORD64(0x983e5152,0xee66dfab, 0xa831c66d,0x2db43210)
WORD64(0xb00327c8,0x98fb213f, 0xbf597fc7,0xbeef0ee4)
WORD64(0xc6e00bf3,0x3da88fc2, 0xd5a79147,0x930aa725)
WORD64(0x06ca6351,0xe003826f, 0x14292967,0x0a0e6e70)
WORD64(0x27b70a85,0x46d22ffc, 0x2e1b2138,0x5c26c926)
WORD64(0x4d2c6dfc,0x5ac42aed, 0x53380d13,0x9d95b3df)
WORD64(0x650a7354,0x8baf63de, 0x766a0abb,0x3c77b2a8)
WORD64(0x81c2c92e,0x47edaee6, 0x92722c85,0x1482353b)
WORD64(0xa2bfe8a1,0x4cf10364, 0xa81a664b,0xbc423001)
WORD64(0xc24b8b70,0xd0f89791, 0xc76c51a3,0x0654be30)
WORD64(0xd192e819,0xd6ef5218, 0xd6990624,0x5565a910)
WORD64(0xf40e3585,0x5771202a, 0x106aa070,0x32bbd1b8)
WORD64(0x19a4c116,0xb8d2d0c8, 0x1e376c08,0x5141ab53)
WORD64(0x2748774c,0xdf8eeb99, 0x34b0bcb5,0xe19b48a8)
WORD64(0x391c0cb3,0xc5c95a63, 0x4ed8aa4a,0xe3418acb)
WORD64(0x5b9cca4f,0x7763e373, 0x682e6ff3,0xd6b2b8a3)
WORD64(0x748f82ee,0x5defb2fc, 0x78a5636f,0x43172f60)
WORD64(0x84c87814,0xa1f0ab72, 0x8cc70208,0x1a6439ec)
WORD64(0x90befffa,0x23631e28, 0xa4506ceb,0xde82bde9)
WORD64(0xbef9a3f7,0xb2c67915, 0xc67178f2,0xe372532b)
WORD64(0xca273ece,0xea26619c, 0xd186b8c7,0x21c0c207)
WORD64(0xeada7dd6,0xcde0eb1e, 0xf57d4f7f,0xee6ed178)
WORD64(0x06f067aa,0x72176fba, 0x0a637dc5,0xa2c898a6)
WORD64(0x113f9804,0xbef90dae, 0x1b710b35,0x131c471b)
WORD64(0x28db77f5,0x23047d84, 0x32caab7b,0x40c72493)
WORD64(0x3c9ebe0a,0x15c9bebc, 0x431d67c4,0x9c100d4c)
WORD64(0x4cc5d4be,0xcb3e42b6, 0x597f299c,0xfc657e2a)
WORD64(0x5fcb6fab,0x3ad6faec, 0x6c44198c,0x4a475817)
.size	K512,.-K512
.LOPENSSL_armcap:
.word	OPENSSL_armcap_P-sha512_block_data_order
.skip	32-4

.global	sha512_block_data_order
.type	sha512_block_data_order,%function
sha512_block_data_order:
	sub	r3,pc,#8		@ sha512_block_data_order
	add	r2,r1,r2,lsl#7	@ len to point at the end of inp
#if __ARM_ARCH__>=7
	ldr	r12,.LOPENSSL_armcap
	ldr	r12,[r3,r12]		@ OPENSSL_armcap_P
	tst	r12,#1
	bne	.LNEON
#endif
	stmdb	sp!,{r4-r12,lr}
	sub	r14,r3,#672		@ K512
	sub	sp,sp,#9*8

	ldr	r7,[r0,#32+LO]
	ldr	r8,[r0,#32+HI]
	ldr	r9, [r0,#48+LO]
	ldr	r10, [r0,#48+HI]
	ldr	r11, [r0,#56+LO]
	ldr	r12, [r0,#56+HI]
.Loop:
	str	r9, [sp,#48+0]
	str	r10, [sp,#48+4]
	str	r11, [sp,#56+0]
	str	r12, [sp,#56+4]
	ldr	r5,[r0,#0+LO]
	ldr	r6,[r0,#0+HI]
	ldr	r3,[r0,#8+LO]
	ldr	r4,[r0,#8+HI]
	ldr	r9, [r0,#16+LO]
	ldr	r10, [r0,#16+HI]
	ldr	r11, [r0,#24+LO]
	ldr	r12, [r0,#24+HI]
	str	r3,[sp,#8+0]
	str	r4,[sp,#8+4]
	str	r9, [sp,#16+0]
	str	r10, [sp,#16+4]
	str	r11, [sp,#24+0]
	str	r12, [sp,#24+4]
	ldr	r3,[r0,#40+LO]
	ldr	r4,[r0,#40+HI]
	str	r3,[sp,#40+0]
	str	r4,[sp,#40+4]

.L00_15:
#if __ARM_ARCH__<7
	ldrb	r3,[r1,#7]
	ldrb	r9, [r1,#6]
	ldrb	r10, [r1,#5]
	ldrb	r11, [r1,#4]
	ldrb	r4,[r1,#3]
	ldrb	r12, [r1,#2]
	orr	r3,r3,r9,lsl#8
	ldrb	r9, [r1,#1]
	orr	r3,r3,r10,lsl#16
	ldrb	r10, [r1],#8
	orr	r3,r3,r11,lsl#24
	orr	r4,r4,r12,lsl#8
	orr	r4,r4,r9,lsl#16
	orr	r4,r4,r10,lsl#24
#else
	ldr	r3,[r1,#4]
	ldr	r4,[r1],#8
#ifdef __ARMEL__
	rev	r3,r3
	rev	r4,r4
#endif
#endif
	@ Sigma1(x)	(ROTR((x),14) ^ ROTR((x),18)  ^ ROTR((x),41))
	@ LO		lo>>14^hi<<18 ^ lo>>18^hi<<14 ^ hi>>9^lo<<23
	@ HI		hi>>14^lo<<18 ^ hi>>18^lo<<14 ^ lo>>9^hi<<23
	mov	r9,r7,lsr#14
	str	r3,[sp,#64+0]
	mov	r10,r8,lsr#14
	str	r4,[sp,#64+4]
	eor	r9,r9,r8,lsl#18
	ldr	r11,[sp,#56+0]	@ h.lo
	eor	r10,r10,r7,lsl#18
	ldr	r12,[sp,#56+4]	@ h.hi
	eor	r9,r9,r7,lsr#18
	eor	r10,r10,r8,lsr#18
	eor	r9,r9,r8,lsl#14
	eor	r10,r10,r7,lsl#14
	eor	r9,r9,r8,lsr#9
	eor	r10,r10,r7,lsr#9
	eor	r9,r9,r7,lsl#23
	eor	r10,r10,r8,lsl#23	@ Sigma1(e)
	adds	r3,r3,r9
	ldr	r9,[sp,#40+0]	@ f.lo
	adc	r4,r4,r10		@ T += Sigma1(e)
	ldr	r10,[sp,#40+4]	@ f.hi
	adds	r3,r3,r11
	ldr	r11,[sp,#48+0]	@ g.lo
	adc	r4,r4,r12		@ T += h
	ldr	r12,[sp,#48+4]	@ g.hi

	eor	r9,r9,r11
	str	r7,[sp,#32+0]
	eor	r10,r10,r12
	str	r8,[sp,#32+4]
	and	r9,r9,r7
	str	r5,[sp,#0+0]
	and	r10,r10,r8
	str	r6,[sp,#0+4]
	eor	r9,r9,r11
	ldr	r11,[r14,#LO]	@ K[i].lo
	eor	r10,r10,r12		@ Ch(e,f,g)
	ldr	r12,[r14,#HI]	@ K[i].hi

	adds	r3,r3,r9
	ldr	r7,[sp,#24+0]	@ d.lo
	adc	r4,r4,r10		@ T += Ch(e,f,g)
	ldr	r8,[sp,#24+4]	@ d.hi
	adds	r3,r3,r11
	and	r9,r11,#0xff
	adc	r4,r4,r12		@ T += K[i]
	adds	r7,r7,r3
	ldr	r11,[sp,#8+0]	@ b.lo
	adc	r8,r8,r4		@ d += T
	teq	r9,#148

	ldr	r12,[sp,#16+0]	@ c.lo
	orreq	r14,r14,#1
	@ Sigma0(x)	(ROTR((x),28) ^ ROTR((x),34) ^ ROTR((x),39))
	@ LO		lo>>28^hi<<4  ^ hi>>2^lo<<30 ^ hi>>7^lo<<25
	@ HI		hi>>28^lo<<4  ^ lo>>2^hi<<30 ^ lo>>7^hi<<25
	mov	r9,r5,lsr#28
	mov	r10,r6,lsr#28
	eor	r9,r9,r6,lsl#4
	eor	r10,r10,r5,lsl#4
	eor	r9,r9,r6,lsr#2
	eor	r10,r10,r5,lsr#2
	eor	r9,r9,r5,lsl#30
	eor	r10,r10,r6,lsl#30
	eor	r9,r9,r6,lsr#7
	eor	r10,r10,r5,lsr#7
	eor	r9,r9,r5,lsl#25
	eor	r10,r10,r6,lsl#25	@ Sigma0(a)
	adds	r3,r3,r9
	and	r9,r5,r11
	adc	r4,r4,r10		@ T += Sigma0(a)

	ldr	r10,[sp,#8+4]	@ b.hi
	orr	r5,r5,r11
	ldr	r11,[sp,#16+4]	@ c.hi
	and	r5,r5,r12
	and	r12,r6,r10
	orr	r6,r6,r10
	orr	r5,r5,r9		@ Maj(a,b,c).lo
	and	r6,r6,r11
	adds	r5,r5,r3
	orr	r6,r6,r12		@ Maj(a,b,c).hi
	sub	sp,sp,#8
	adc	r6,r6,r4		@ h += T
	tst	r14,#1
	add	r14,r14,#8
	tst	r14,#1
	beq	.L00_15
	ldr	r9,[sp,#184+0]
	ldr	r10,[sp,#184+4]
	bic	r14,r14,#1
.L16_79:
	@ sigma0(x)	(ROTR((x),1)  ^ ROTR((x),8)  ^ ((x)>>7))
	@ LO		lo>>1^hi<<31  ^ lo>>8^hi<<24 ^ lo>>7^hi<<25
	@ HI		hi>>1^lo<<31  ^ hi>>8^lo<<24 ^ hi>>7
	mov	r3,r9,lsr#1
	ldr	r11,[sp,#80+0]
	mov	r4,r10,lsr#1
	ldr	r12,[sp,#80+4]
	eor	r3,r3,r10,lsl#31
	eor	r4,r4,r9,lsl#31
	eor	r3,r3,r9,lsr#8
	eor	r4,r4,r10,lsr#8
	eor	r3,r3,r10,lsl#24
	eor	r4,r4,r9,lsl#24
	eor	r3,r3,r9,lsr#7
	eor	r4,r4,r10,lsr#7
	eor	r3,r3,r10,lsl#25

	@ sigma1(x)	(ROTR((x),19) ^ ROTR((x),61) ^ ((x)>>6))
	@ LO		lo>>19^hi<<13 ^ hi>>29^lo<<3 ^ lo>>6^hi<<26
	@ HI		hi>>19^lo<<13 ^ lo>>29^hi<<3 ^ hi>>6
	mov	r9,r11,lsr#19
	mov	r10,r12,lsr#19
	eor	r9,r9,r12,lsl#13
	eor	r10,r10,r11,lsl#13
	eor	r9,r9,r12,lsr#29
	eor	r10,r10,r11,lsr#29
	eor	r9,r9,r11,lsl#3
	eor	r10,r10,r12,lsl#3
	eor	r9,r9,r11,lsr#6
	eor	r10,r10,r12,lsr#6
	ldr	r11,[sp,#120+0]
	eor	r9,r9,r12,lsl#26

	ldr	r12,[sp,#120+4]
	adds	r3,r3,r9
	ldr	r9,[sp,#192+0]
	adc	r4,r4,r10

	ldr	r10,[sp,#192+4]
	adds	r3,r3,r11
	adc	r4,r4,r12
	adds	r3,r3,r9
	adc	r4,r4,r10
	@ Sigma1(x)	(ROTR((x),14) ^ ROTR((x),18)  ^ ROTR((x),41))
	@ LO		lo>>14^hi<<18 ^ lo>>18^hi<<14 ^ hi>>9^lo<<23
	@ HI		hi>>14^lo<<18 ^ hi>>18^lo<<14 ^ lo>>9^hi<<23
	mov	r9,r7,lsr#14
	str	r3,[sp,#64+0]
	mov	r10,r8,lsr#14
	str	r4,[sp,#64+4]
	eor	r9,r9,r8,lsl#18
	ldr	r11,[sp,#56+0]	@ h.lo
	eor	r10,r10,r7,lsl#18
	ldr	r12,[sp,#56+4]	@ h.hi
	eor	r9,r9,r7,lsr#18
	eor	r10,r10,r8,lsr#18
	eor	r9,r9,r8,lsl#14
	eor	r10,r10,r7,lsl#14
	eor	r9,r9,r8,lsr#9
	eor	r10,r10,r7,lsr#9
	eor	r9,r9,r7,lsl#23
	eor	r10,r10,r8,lsl#23	@ Sigma1(e)
	adds	r3,r3,r9
	ldr	r9,[sp,#40+0]	@ f.lo
	adc	r4,r4,r10		@ T += Sigma1(e)
	ldr	r10,[sp,#40+4]	@ f.hi
	adds	r3,r3,r11
	ldr	r11,[sp,#48+0]	@ g.lo
	adc	r4,r4,r12		@ T += h
	ldr	r12,[sp,#48+4]	@ g.hi

	eor	r9,r9,r11
	str	r7,[sp,#32+0]
	eor	r10,r10,r12
	str	r8,[sp,#32+4]
	and	r9,r9,r7
	str	r5,[sp,#0+0]
	and	r10,r10,r8
	str	r6,[sp,#0+4]
	eor	r9,r9,r11
	ldr	r11,[r14,#LO]	@ K[i].lo
	eor	r10,r10,r12		@ Ch(e,f,g)
	ldr	r12,[r14,#HI]	@ K[i].hi

	adds	r3,r3,r9
	ldr	r7,[sp,#24+0]	@ d.lo
	adc	r4,r4,r10		@ T += Ch(e,f,g)
	ldr	r8,[sp,#24+4]	@ d.hi
	adds	r3,r3,r11
	and	r9,r11,#0xff
	adc	r4,r4,r12		@ T += K[i]
	adds	r7,r7,r3
	ldr	r11,[sp,#8+0]	@ b.lo
	adc	r8,r8,r4		@ d += T
	teq	r9,#23

	ldr	r12,[sp,#16+0]	@ c.lo
	orreq	r14,r14,#1
	@ Sigma0(x)	(ROTR((x),28) ^ ROTR((x),34) ^ ROTR((x),39))
	@ LO		lo>>28^hi<<4  ^ hi>>2^lo<<30 ^ hi>>7^lo<<25
	@ HI		hi>>28^lo<<4  ^ lo>>2^hi<<30 ^ lo>>7^hi<<25
	mov	r9,r5,lsr#28
	mov	r10,r6,lsr#28
	eor	r9,r9,r6,lsl#4
	eor	r10,r10,r5,lsl#4
	eor	r9,r9,r6,lsr#2
	eor	r10,r10,r5,lsr#2
	eor	r9,r9,r5,lsl#30
	eor	r10,r10,r6,lsl#30
	eor	r9,r9,r6,lsr#7
	eor	r10,r10,r5,lsr#7
	eor	r9,r9,r5,lsl#25
	eor	r10,r10,r6,lsl#25	@ Sigma0(a)
	adds	r3,r3,r9
	and	r9,r5,r11
	adc	r4,r4,r10		@ T += Sigma0(a)

	ldr	r10,[sp,#8+4]	@ b.hi
	orr	r5,r5,r11
	ldr	r11,[sp,#16+4]	@ c.hi
	and	r5,r5,r12
	and	r12,r6,r10
	orr	r6,r6,r10
	orr	r5,r5,r9		@ Maj(a,b,c).lo
	and	r6,r6,r11
	adds	r5,r5,r3
	orr	r6,r6,r12		@ Maj(a,b,c).hi
	sub	sp,sp,#8
	adc	r6,r6,r4		@ h += T
	tst	r14,#1
	add	r14,r14,#8
	ldreq	r9,[sp,#184+0]
	ldreq	r10,[sp,#184+4]
	beq	.L16_79
	bic	r14,r14,#1

	ldr	r3,[sp,#8+0]
	ldr	r4,[sp,#8+4]
	ldr	r9, [r0,#0+LO]
	ldr	r10, [r0,#0+HI]
	ldr	r11, [r0,#8+LO]
	ldr	r12, [r0,#8+HI]
	adds	r9,r5,r9
	str	r9, [r0,#0+LO]
	adc	r10,r6,r10
	str	r10, [r0,#0+HI]
	adds	r11,r3,r11
	str	r11, [r0,#8+LO]
	adc	r12,r4,r12
	str	r12, [r0,#8+HI]

	ldr	r5,[sp,#16+0]
	ldr	r6,[sp,#16+4]
	ldr	r3,[sp,#24+0]
	ldr	r4,[sp,#24+4]
	ldr	r9, [r0,#16+LO]
	ldr	r10, [r0,#16+HI]
	ldr	r11, [r0,#24+LO]
	ldr	r12, [r0,#24+HI]
	adds	r9,r5,r9
	str	r9, [r0,#16+LO]
	adc	r10,r6,r10
	str	r10, [r0,#16+HI]
	adds	r11,r3,r11
	str	r11, [r0,#24+LO]
	adc	r12,r4,r12
	str	r12, [r0,#24+HI]

	ldr	r3,[sp,#40+0]
	ldr	r4,[sp,#40+4]
	ldr	r9, [r0,#32+LO]
	ldr	r10, [r0,#32+HI]
	ldr	r11, [r0,#40+LO]
	ldr	r12, [r0,#40+HI]
	adds	r7,r7,r9
	str	r7,[r0,#32+LO]
	adc	r8,r8,r10
	str	r8,[r0,#32+HI]
	adds	r11,r3,r11
	str	r11, [r0,#40+LO]
	adc	r12,r4,r12
	str	r12, [r0,#40+HI]

	ldr	r5,[sp,#48+0]
	ldr	r6,[sp,#48+4]
	ldr	r3,[sp,#56+0]
	ldr	r4,[sp,#56+4]
	ldr	r9, [r0,#48+LO]
	ldr	r10, [r0,#48+HI]
	ldr	r11, [r0,#56+LO]
	ldr	r12, [r0,#56+HI]
	adds	r9,r5,r9
	str	r9, [r0,#48+LO]
	adc	r10,r6,r10
	str	r10, [r0,#48+HI]
	adds	r11,r3,r11
	str	r11, [r0,#56+LO]
	adc	r12,r4,r12
	str	r12, [r0,#56+HI]

	add	sp,sp,#640
	sub	r14,r14,#640

	teq	r1,r2
	bne	.Loop

	add	sp,sp,#8*9		@ destroy frame
#if __ARM_ARCH__>=5
	ldmia	sp!,{r4-r12,pc}
#else
	ldmia	sp!,{r4-r12,lr}
	tst	lr,#1
	moveq	pc,lr			@ be binary compatible with V4, yet
	.word	0xe12fff1e			@ interoperable with Thumb ISA:-)
#endif
#if __ARM_ARCH__>=7
.fpu	neon

.align	4
.LNEON:
	dmb				@ errata #451034 on early Cortex A8
	vstmdb	sp!,{d8-d15}		@ ABI specification says so
	sub	r3,r3,#672		@ K512
	vldmia	r0,{d16-d23}		@ load context
.Loop_neon:
	vshr.u64	d24,d20,#14	@ 0
#if 0<16
	vld1.64		{d0},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d20,#18
	vshr.u64	d26,d20,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d20,#50
	vsli.64		d25,d20,#46
	vsli.64		d26,d20,#23
#if 0<16 && defined(__ARMEL__)
	vrev64.8	d0,d0
#endif
	vadd.i64	d27,d28,d23
	veor		d29,d21,d22
	veor		d24,d25
	vand		d29,d20
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d22			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d16,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d16,#34
	vshr.u64	d26,d16,#39
	vsli.64		d24,d16,#36
	vsli.64		d25,d16,#30
	vsli.64		d26,d16,#25
	vadd.i64	d27,d0
	vorr		d30,d16,d18
	vand		d29,d16,d18
	veor		d23,d24,d25
	vand		d30,d17
	veor		d23,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d23,d27
	vadd.i64	d19,d27
	vadd.i64	d23,d30
	vshr.u64	d24,d19,#14	@ 1
#if 1<16
	vld1.64		{d1},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d19,#18
	vshr.u64	d26,d19,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d19,#50
	vsli.64		d25,d19,#46
	vsli.64		d26,d19,#23
#if 1<16 && defined(__ARMEL__)
	vrev64.8	d1,d1
#endif
	vadd.i64	d27,d28,d22
	veor		d29,d20,d21
	veor		d24,d25
	vand		d29,d19
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d21			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d23,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d23,#34
	vshr.u64	d26,d23,#39
	vsli.64		d24,d23,#36
	vsli.64		d25,d23,#30
	vsli.64		d26,d23,#25
	vadd.i64	d27,d1
	vorr		d30,d23,d17
	vand		d29,d23,d17
	veor		d22,d24,d25
	vand		d30,d16
	veor		d22,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d22,d27
	vadd.i64	d18,d27
	vadd.i64	d22,d30
	vshr.u64	d24,d18,#14	@ 2
#if 2<16
	vld1.64		{d2},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d18,#18
	vshr.u64	d26,d18,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d18,#50
	vsli.64		d25,d18,#46
	vsli.64		d26,d18,#23
#if 2<16 && defined(__ARMEL__)
	vrev64.8	d2,d2
#endif
	vadd.i64	d27,d28,d21
	veor		d29,d19,d20
	veor		d24,d25
	vand		d29,d18
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d20			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d22,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d22,#34
	vshr.u64	d26,d22,#39
	vsli.64		d24,d22,#36
	vsli.64		d25,d22,#30
	vsli.64		d26,d22,#25
	vadd.i64	d27,d2
	vorr		d30,d22,d16
	vand		d29,d22,d16
	veor		d21,d24,d25
	vand		d30,d23
	veor		d21,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d21,d27
	vadd.i64	d17,d27
	vadd.i64	d21,d30
	vshr.u64	d24,d17,#14	@ 3
#if 3<16
	vld1.64		{d3},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d17,#18
	vshr.u64	d26,d17,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d17,#50
	vsli.64		d25,d17,#46
	vsli.64		d26,d17,#23
#if 3<16 && defined(__ARMEL__)
	vrev64.8	d3,d3
#endif
	vadd.i64	d27,d28,d20
	veor		d29,d18,d19
	veor		d24,d25
	vand		d29,d17
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d19			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d21,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d21,#34
	vshr.u64	d26,d21,#39
	vsli.64		d24,d21,#36
	vsli.64		d25,d21,#30
	vsli.64		d26,d21,#25
	vadd.i64	d27,d3
	vorr		d30,d21,d23
	vand		d29,d21,d23
	veor		d20,d24,d25
	vand		d30,d22
	veor		d20,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d20,d27
	vadd.i64	d16,d27
	vadd.i64	d20,d30
	vshr.u64	d24,d16,#14	@ 4
#if 4<16
	vld1.64		{d4},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d16,#18
	vshr.u64	d26,d16,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d16,#50
	vsli.64		d25,d16,#46
	vsli.64		d26,d16,#23
#if 4<16 && defined(__ARMEL__)
	vrev64.8	d4,d4
#endif
	vadd.i64	d27,d28,d19
	veor		d29,d17,d18
	veor		d24,d25
	vand		d29,d16
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d18			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d20,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d20,#34
	vshr.u64	d26,d20,#39
	vsli.64		d24,d20,#36
	vsli.64		d25,d20,#30
	vsli.64		d26,d20,#25
	vadd.i64	d27,d4
	vorr		d30,d20,d22
	vand		d29,d20,d22
	veor		d19,d24,d25
	vand		d30,d21
	veor		d19,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d19,d27
	vadd.i64	d23,d27
	vadd.i64	d19,d30
	vshr.u64	d24,d23,#14	@ 5
#if 5<16
	vld1.64		{d5},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d23,#18
	vshr.u64	d26,d23,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d23,#50
	vsli.64		d25,d23,#46
	vsli.64		d26,d23,#23
#if 5<16 && defined(__ARMEL__)
	vrev64.8	d5,d5
#endif
	vadd.i64	d27,d28,d18
	veor		d29,d16,d17
	veor		d24,d25
	vand		d29,d23
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d17			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d19,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d19,#34
	vshr.u64	d26,d19,#39
	vsli.64		d24,d19,#36
	vsli.64		d25,d19,#30
	vsli.64		d26,d19,#25
	vadd.i64	d27,d5
	vorr		d30,d19,d21
	vand		d29,d19,d21
	veor		d18,d24,d25
	vand		d30,d20
	veor		d18,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d18,d27
	vadd.i64	d22,d27
	vadd.i64	d18,d30
	vshr.u64	d24,d22,#14	@ 6
#if 6<16
	vld1.64		{d6},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d22,#18
	vshr.u64	d26,d22,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d22,#50
	vsli.64		d25,d22,#46
	vsli.64		d26,d22,#23
#if 6<16 && defined(__ARMEL__)
	vrev64.8	d6,d6
#endif
	vadd.i64	d27,d28,d17
	veor		d29,d23,d16
	veor		d24,d25
	vand		d29,d22
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d16			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d18,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d18,#34
	vshr.u64	d26,d18,#39
	vsli.64		d24,d18,#36
	vsli.64		d25,d18,#30
	vsli.64		d26,d18,#25
	vadd.i64	d27,d6
	vorr		d30,d18,d20
	vand		d29,d18,d20
	veor		d17,d24,d25
	vand		d30,d19
	veor		d17,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d17,d27
	vadd.i64	d21,d27
	vadd.i64	d17,d30
	vshr.u64	d24,d21,#14	@ 7
#if 7<16
	vld1.64		{d7},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d21,#18
	vshr.u64	d26,d21,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d21,#50
	vsli.64		d25,d21,#46
	vsli.64		d26,d21,#23
#if 7<16 && defined(__ARMEL__)
	vrev64.8	d7,d7
#endif
	vadd.i64	d27,d28,d16
	veor		d29,d22,d23
	veor		d24,d25
	vand		d29,d21
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d23			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d17,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d17,#34
	vshr.u64	d26,d17,#39
	vsli.64		d24,d17,#36
	vsli.64		d25,d17,#30
	vsli.64		d26,d17,#25
	vadd.i64	d27,d7
	vorr		d30,d17,d19
	vand		d29,d17,d19
	veor		d16,d24,d25
	vand		d30,d18
	veor		d16,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d16,d27
	vadd.i64	d20,d27
	vadd.i64	d16,d30
	vshr.u64	d24,d20,#14	@ 8
#if 8<16
	vld1.64		{d8},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d20,#18
	vshr.u64	d26,d20,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d20,#50
	vsli.64		d25,d20,#46
	vsli.64		d26,d20,#23
#if 8<16 && defined(__ARMEL__)
	vrev64.8	d8,d8
#endif
	vadd.i64	d27,d28,d23
	veor		d29,d21,d22
	veor		d24,d25
	vand		d29,d20
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d22			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d16,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d16,#34
	vshr.u64	d26,d16,#39
	vsli.64		d24,d16,#36
	vsli.64		d25,d16,#30
	vsli.64		d26,d16,#25
	vadd.i64	d27,d8
	vorr		d30,d16,d18
	vand		d29,d16,d18
	veor		d23,d24,d25
	vand		d30,d17
	veor		d23,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d23,d27
	vadd.i64	d19,d27
	vadd.i64	d23,d30
	vshr.u64	d24,d19,#14	@ 9
#if 9<16
	vld1.64		{d9},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d19,#18
	vshr.u64	d26,d19,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d19,#50
	vsli.64		d25,d19,#46
	vsli.64		d26,d19,#23
#if 9<16 && defined(__ARMEL__)
	vrev64.8	d9,d9
#endif
	vadd.i64	d27,d28,d22
	veor		d29,d20,d21
	veor		d24,d25
	vand		d29,d19
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d21			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d23,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d23,#34
	vshr.u64	d26,d23,#39
	vsli.64		d24,d23,#36
	vsli.64		d25,d23,#30
	vsli.64		d26,d23,#25
	vadd.i64	d27,d9
	vorr		d30,d23,d17
	vand		d29,d23,d17
	veor		d22,d24,d25
	vand		d30,d16
	veor		d22,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d22,d27
	vadd.i64	d18,d27
	vadd.i64	d22,d30
	vshr.u64	d24,d18,#14	@ 10
#if 10<16
	vld1.64		{d10},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d18,#18
	vshr.u64	d26,d18,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d18,#50
	vsli.64		d25,d18,#46
	vsli.64		d26,d18,#23
#if 10<16 && defined(__ARMEL__)
	vrev64.8	d10,d10
#endif
	vadd.i64	d27,d28,d21
	veor		d29,d19,d20
	veor		d24,d25
	vand		d29,d18
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d20			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d22,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d22,#34
	vshr.u64	d26,d22,#39
	vsli.64		d24,d22,#36
	vsli.64		d25,d22,#30
	vsli.64		d26,d22,#25
	vadd.i64	d27,d10
	vorr		d30,d22,d16
	vand		d29,d22,d16
	veor		d21,d24,d25
	vand		d30,d23
	veor		d21,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d21,d27
	vadd.i64	d17,d27
	vadd.i64	d21,d30
	vshr.u64	d24,d17,#14	@ 11
#if 11<16
	vld1.64		{d11},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d17,#18
	vshr.u64	d26,d17,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d17,#50
	vsli.64		d25,d17,#46
	vsli.64		d26,d17,#23
#if 11<16 && defined(__ARMEL__)
	vrev64.8	d11,d11
#endif
	vadd.i64	d27,d28,d20
	veor		d29,d18,d19
	veor		d24,d25
	vand		d29,d17
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d19			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d21,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d21,#34
	vshr.u64	d26,d21,#39
	vsli.64		d24,d21,#36
	vsli.64		d25,d21,#30
	vsli.64		d26,d21,#25
	vadd.i64	d27,d11
	vorr		d30,d21,d23
	vand		d29,d21,d23
	veor		d20,d24,d25
	vand		d30,d22
	veor		d20,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d20,d27
	vadd.i64	d16,d27
	vadd.i64	d20,d30
	vshr.u64	d24,d16,#14	@ 12
#if 12<16
	vld1.64		{d12},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d16,#18
	vshr.u64	d26,d16,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d16,#50
	vsli.64		d25,d16,#46
	vsli.64		d26,d16,#23
#if 12<16 && defined(__ARMEL__)
	vrev64.8	d12,d12
#endif
	vadd.i64	d27,d28,d19
	veor		d29,d17,d18
	veor		d24,d25
	vand		d29,d16
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d18			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d20,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d20,#34
	vshr.u64	d26,d20,#39
	vsli.64		d24,d20,#36
	vsli.64		d25,d20,#30
	vsli.64		d26,d20,#25
	vadd.i64	d27,d12
	vorr		d30,d20,d22
	vand		d29,d20,d22
	veor		d19,d24,d25
	vand		d30,d21
	veor		d19,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d19,d27
	vadd.i64	d23,d27
	vadd.i64	d19,d30
	vshr.u64	d24,d23,#14	@ 13
#if 13<16
	vld1.64		{d13},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d23,#18
	vshr.u64	d26,d23,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d23,#50
	vsli.64		d25,d23,#46
	vsli.64		d26,d23,#23
#if 13<16 && defined(__ARMEL__)
	vrev64.8	d13,d13
#endif
	vadd.i64	d27,d28,d18
	veor		d29,d16,d17
	veor		d24,d25
	vand		d29,d23
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d17			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d19,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d19,#34
	vshr.u64	d26,d19,#39
	vsli.64		d24,d19,#36
	vsli.64		d25,d19,#30
	vsli.64		d26,d19,#25
	vadd.i64	d27,d13
	vorr		d30,d19,d21
	vand		d29,d19,d21
	veor		d18,d24,d25
	vand		d30,d20
	veor		d18,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d18,d27
	vadd.i64	d22,d27
	vadd.i64	d18,d30
	vshr.u64	d24,d22,#14	@ 14
#if 14<16
	vld1.64		{d14},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d22,#18
	vshr.u64	d26,d22,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d22,#50
	vsli.64		d25,d22,#46
	vsli.64		d26,d22,#23
#if 14<16 && defined(__ARMEL__)
	vrev64.8	d14,d14
#endif
	vadd.i64	d27,d28,d17
	veor		d29,d23,d16
	veor		d24,d25
	vand		d29,d22
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d16			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d18,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d18,#34
	vshr.u64	d26,d18,#39
	vsli.64		d24,d18,#36
	vsli.64		d25,d18,#30
	vsli.64		d26,d18,#25
	vadd.i64	d27,d14
	vorr		d30,d18,d20
	vand		d29,d18,d20
	veor		d17,d24,d25
	vand		d30,d19
	veor		d17,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d17,d27
	vadd.i64	d21,d27
	vadd.i64	d17,d30
	vshr.u64	d24,d21,#14	@ 15
#if 15<16
	vld1.64		{d15},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d21,#18
	vshr.u64	d26,d21,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d21,#50
	vsli.64		d25,d21,#46
	vsli.64		d26,d21,#23
#if 15<16 && defined(__ARMEL__)
	vrev64.8	d15,d15
#endif
	vadd.i64	d27,d28,d16
	veor		d29,d22,d23
	veor		d24,d25
	vand		d29,d21
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d23			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d17,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d17,#34
	vshr.u64	d26,d17,#39
	vsli.64		d24,d17,#36
	vsli.64		d25,d17,#30
	vsli.64		d26,d17,#25
	vadd.i64	d27,d15
	vorr		d30,d17,d19
	vand		d29,d17,d19
	veor		d16,d24,d25
	vand		d30,d18
	veor		d16,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d16,d27
	vadd.i64	d20,d27
	vadd.i64	d16,d30
	mov		r12,#4
.L16_79_neon:
	subs		r12,#1
	vshr.u64	q12,q7,#19
	vshr.u64	q13,q7,#61
	vshr.u64	q15,q7,#6
	vsli.64		q12,q7,#45
	vext.8		q14,q0,q1,#8	@ X[i+1]
	vsli.64		q13,q7,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q0,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q4,q5,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d20,#14		@ from NEON_00_15
	vadd.i64	q0,q14
	vshr.u64	d25,d20,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d20,#41		@ from NEON_00_15
	vadd.i64	q0,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d20,#50
	vsli.64		d25,d20,#46
	vsli.64		d26,d20,#23
#if 16<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d23
	veor		d29,d21,d22
	veor		d24,d25
	vand		d29,d20
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d22			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d16,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d16,#34
	vshr.u64	d26,d16,#39
	vsli.64		d24,d16,#36
	vsli.64		d25,d16,#30
	vsli.64		d26,d16,#25
	vadd.i64	d27,d0
	vorr		d30,d16,d18
	vand		d29,d16,d18
	veor		d23,d24,d25
	vand		d30,d17
	veor		d23,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d23,d27
	vadd.i64	d19,d27
	vadd.i64	d23,d30
	vshr.u64	d24,d19,#14	@ 17
#if 17<16
	vld1.64		{d1},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d19,#18
	vshr.u64	d26,d19,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d19,#50
	vsli.64		d25,d19,#46
	vsli.64		d26,d19,#23
#if 17<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d22
	veor		d29,d20,d21
	veor		d24,d25
	vand		d29,d19
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d21			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d23,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d23,#34
	vshr.u64	d26,d23,#39
	vsli.64		d24,d23,#36
	vsli.64		d25,d23,#30
	vsli.64		d26,d23,#25
	vadd.i64	d27,d1
	vorr		d30,d23,d17
	vand		d29,d23,d17
	veor		d22,d24,d25
	vand		d30,d16
	veor		d22,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d22,d27
	vadd.i64	d18,d27
	vadd.i64	d22,d30
	vshr.u64	q12,q0,#19
	vshr.u64	q13,q0,#61
	vshr.u64	q15,q0,#6
	vsli.64		q12,q0,#45
	vext.8		q14,q1,q2,#8	@ X[i+1]
	vsli.64		q13,q0,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q1,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q5,q6,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d18,#14		@ from NEON_00_15
	vadd.i64	q1,q14
	vshr.u64	d25,d18,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d18,#41		@ from NEON_00_15
	vadd.i64	q1,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d18,#50
	vsli.64		d25,d18,#46
	vsli.64		d26,d18,#23
#if 18<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d21
	veor		d29,d19,d20
	veor		d24,d25
	vand		d29,d18
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d20			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d22,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d22,#34
	vshr.u64	d26,d22,#39
	vsli.64		d24,d22,#36
	vsli.64		d25,d22,#30
	vsli.64		d26,d22,#25
	vadd.i64	d27,d2
	vorr		d30,d22,d16
	vand		d29,d22,d16
	veor		d21,d24,d25
	vand		d30,d23
	veor		d21,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d21,d27
	vadd.i64	d17,d27
	vadd.i64	d21,d30
	vshr.u64	d24,d17,#14	@ 19
#if 19<16
	vld1.64		{d3},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d17,#18
	vshr.u64	d26,d17,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d17,#50
	vsli.64		d25,d17,#46
	vsli.64		d26,d17,#23
#if 19<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d20
	veor		d29,d18,d19
	veor		d24,d25
	vand		d29,d17
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d19			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d21,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d21,#34
	vshr.u64	d26,d21,#39
	vsli.64		d24,d21,#36
	vsli.64		d25,d21,#30
	vsli.64		d26,d21,#25
	vadd.i64	d27,d3
	vorr		d30,d21,d23
	vand		d29,d21,d23
	veor		d20,d24,d25
	vand		d30,d22
	veor		d20,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d20,d27
	vadd.i64	d16,d27
	vadd.i64	d20,d30
	vshr.u64	q12,q1,#19
	vshr.u64	q13,q1,#61
	vshr.u64	q15,q1,#6
	vsli.64		q12,q1,#45
	vext.8		q14,q2,q3,#8	@ X[i+1]
	vsli.64		q13,q1,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q2,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q6,q7,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d16,#14		@ from NEON_00_15
	vadd.i64	q2,q14
	vshr.u64	d25,d16,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d16,#41		@ from NEON_00_15
	vadd.i64	q2,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d16,#50
	vsli.64		d25,d16,#46
	vsli.64		d26,d16,#23
#if 20<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d19
	veor		d29,d17,d18
	veor		d24,d25
	vand		d29,d16
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d18			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d20,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d20,#34
	vshr.u64	d26,d20,#39
	vsli.64		d24,d20,#36
	vsli.64		d25,d20,#30
	vsli.64		d26,d20,#25
	vadd.i64	d27,d4
	vorr		d30,d20,d22
	vand		d29,d20,d22
	veor		d19,d24,d25
	vand		d30,d21
	veor		d19,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d19,d27
	vadd.i64	d23,d27
	vadd.i64	d19,d30
	vshr.u64	d24,d23,#14	@ 21
#if 21<16
	vld1.64		{d5},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d23,#18
	vshr.u64	d26,d23,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d23,#50
	vsli.64		d25,d23,#46
	vsli.64		d26,d23,#23
#if 21<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d18
	veor		d29,d16,d17
	veor		d24,d25
	vand		d29,d23
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d17			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d19,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d19,#34
	vshr.u64	d26,d19,#39
	vsli.64		d24,d19,#36
	vsli.64		d25,d19,#30
	vsli.64		d26,d19,#25
	vadd.i64	d27,d5
	vorr		d30,d19,d21
	vand		d29,d19,d21
	veor		d18,d24,d25
	vand		d30,d20
	veor		d18,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d18,d27
	vadd.i64	d22,d27
	vadd.i64	d18,d30
	vshr.u64	q12,q2,#19
	vshr.u64	q13,q2,#61
	vshr.u64	q15,q2,#6
	vsli.64		q12,q2,#45
	vext.8		q14,q3,q4,#8	@ X[i+1]
	vsli.64		q13,q2,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q3,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q7,q0,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d22,#14		@ from NEON_00_15
	vadd.i64	q3,q14
	vshr.u64	d25,d22,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d22,#41		@ from NEON_00_15
	vadd.i64	q3,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d22,#50
	vsli.64		d25,d22,#46
	vsli.64		d26,d22,#23
#if 22<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d17
	veor		d29,d23,d16
	veor		d24,d25
	vand		d29,d22
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d16			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d18,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d18,#34
	vshr.u64	d26,d18,#39
	vsli.64		d24,d18,#36
	vsli.64		d25,d18,#30
	vsli.64		d26,d18,#25
	vadd.i64	d27,d6
	vorr		d30,d18,d20
	vand		d29,d18,d20
	veor		d17,d24,d25
	vand		d30,d19
	veor		d17,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d17,d27
	vadd.i64	d21,d27
	vadd.i64	d17,d30
	vshr.u64	d24,d21,#14	@ 23
#if 23<16
	vld1.64		{d7},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d21,#18
	vshr.u64	d26,d21,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d21,#50
	vsli.64		d25,d21,#46
	vsli.64		d26,d21,#23
#if 23<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d16
	veor		d29,d22,d23
	veor		d24,d25
	vand		d29,d21
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d23			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d17,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d17,#34
	vshr.u64	d26,d17,#39
	vsli.64		d24,d17,#36
	vsli.64		d25,d17,#30
	vsli.64		d26,d17,#25
	vadd.i64	d27,d7
	vorr		d30,d17,d19
	vand		d29,d17,d19
	veor		d16,d24,d25
	vand		d30,d18
	veor		d16,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d16,d27
	vadd.i64	d20,d27
	vadd.i64	d16,d30
	vshr.u64	q12,q3,#19
	vshr.u64	q13,q3,#61
	vshr.u64	q15,q3,#6
	vsli.64		q12,q3,#45
	vext.8		q14,q4,q5,#8	@ X[i+1]
	vsli.64		q13,q3,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q4,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q0,q1,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d20,#14		@ from NEON_00_15
	vadd.i64	q4,q14
	vshr.u64	d25,d20,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d20,#41		@ from NEON_00_15
	vadd.i64	q4,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d20,#50
	vsli.64		d25,d20,#46
	vsli.64		d26,d20,#23
#if 24<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d23
	veor		d29,d21,d22
	veor		d24,d25
	vand		d29,d20
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d22			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d16,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d16,#34
	vshr.u64	d26,d16,#39
	vsli.64		d24,d16,#36
	vsli.64		d25,d16,#30
	vsli.64		d26,d16,#25
	vadd.i64	d27,d8
	vorr		d30,d16,d18
	vand		d29,d16,d18
	veor		d23,d24,d25
	vand		d30,d17
	veor		d23,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d23,d27
	vadd.i64	d19,d27
	vadd.i64	d23,d30
	vshr.u64	d24,d19,#14	@ 25
#if 25<16
	vld1.64		{d9},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d19,#18
	vshr.u64	d26,d19,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d19,#50
	vsli.64		d25,d19,#46
	vsli.64		d26,d19,#23
#if 25<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d22
	veor		d29,d20,d21
	veor		d24,d25
	vand		d29,d19
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d21			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d23,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d23,#34
	vshr.u64	d26,d23,#39
	vsli.64		d24,d23,#36
	vsli.64		d25,d23,#30
	vsli.64		d26,d23,#25
	vadd.i64	d27,d9
	vorr		d30,d23,d17
	vand		d29,d23,d17
	veor		d22,d24,d25
	vand		d30,d16
	veor		d22,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d22,d27
	vadd.i64	d18,d27
	vadd.i64	d22,d30
	vshr.u64	q12,q4,#19
	vshr.u64	q13,q4,#61
	vshr.u64	q15,q4,#6
	vsli.64		q12,q4,#45
	vext.8		q14,q5,q6,#8	@ X[i+1]
	vsli.64		q13,q4,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q5,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q1,q2,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d18,#14		@ from NEON_00_15
	vadd.i64	q5,q14
	vshr.u64	d25,d18,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d18,#41		@ from NEON_00_15
	vadd.i64	q5,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d18,#50
	vsli.64		d25,d18,#46
	vsli.64		d26,d18,#23
#if 26<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d21
	veor		d29,d19,d20
	veor		d24,d25
	vand		d29,d18
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d20			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d22,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d22,#34
	vshr.u64	d26,d22,#39
	vsli.64		d24,d22,#36
	vsli.64		d25,d22,#30
	vsli.64		d26,d22,#25
	vadd.i64	d27,d10
	vorr		d30,d22,d16
	vand		d29,d22,d16
	veor		d21,d24,d25
	vand		d30,d23
	veor		d21,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d21,d27
	vadd.i64	d17,d27
	vadd.i64	d21,d30
	vshr.u64	d24,d17,#14	@ 27
#if 27<16
	vld1.64		{d11},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d17,#18
	vshr.u64	d26,d17,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d17,#50
	vsli.64		d25,d17,#46
	vsli.64		d26,d17,#23
#if 27<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d20
	veor		d29,d18,d19
	veor		d24,d25
	vand		d29,d17
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d19			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d21,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d21,#34
	vshr.u64	d26,d21,#39
	vsli.64		d24,d21,#36
	vsli.64		d25,d21,#30
	vsli.64		d26,d21,#25
	vadd.i64	d27,d11
	vorr		d30,d21,d23
	vand		d29,d21,d23
	veor		d20,d24,d25
	vand		d30,d22
	veor		d20,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d20,d27
	vadd.i64	d16,d27
	vadd.i64	d20,d30
	vshr.u64	q12,q5,#19
	vshr.u64	q13,q5,#61
	vshr.u64	q15,q5,#6
	vsli.64		q12,q5,#45
	vext.8		q14,q6,q7,#8	@ X[i+1]
	vsli.64		q13,q5,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q6,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q2,q3,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d16,#14		@ from NEON_00_15
	vadd.i64	q6,q14
	vshr.u64	d25,d16,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d16,#41		@ from NEON_00_15
	vadd.i64	q6,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d16,#50
	vsli.64		d25,d16,#46
	vsli.64		d26,d16,#23
#if 28<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d19
	veor		d29,d17,d18
	veor		d24,d25
	vand		d29,d16
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d18			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d20,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d20,#34
	vshr.u64	d26,d20,#39
	vsli.64		d24,d20,#36
	vsli.64		d25,d20,#30
	vsli.64		d26,d20,#25
	vadd.i64	d27,d12
	vorr		d30,d20,d22
	vand		d29,d20,d22
	veor		d19,d24,d25
	vand		d30,d21
	veor		d19,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d19,d27
	vadd.i64	d23,d27
	vadd.i64	d19,d30
	vshr.u64	d24,d23,#14	@ 29
#if 29<16
	vld1.64		{d13},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d23,#18
	vshr.u64	d26,d23,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d23,#50
	vsli.64		d25,d23,#46
	vsli.64		d26,d23,#23
#if 29<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d18
	veor		d29,d16,d17
	veor		d24,d25
	vand		d29,d23
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d17			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d19,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d19,#34
	vshr.u64	d26,d19,#39
	vsli.64		d24,d19,#36
	vsli.64		d25,d19,#30
	vsli.64		d26,d19,#25
	vadd.i64	d27,d13
	vorr		d30,d19,d21
	vand		d29,d19,d21
	veor		d18,d24,d25
	vand		d30,d20
	veor		d18,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d18,d27
	vadd.i64	d22,d27
	vadd.i64	d18,d30
	vshr.u64	q12,q6,#19
	vshr.u64	q13,q6,#61
	vshr.u64	q15,q6,#6
	vsli.64		q12,q6,#45
	vext.8		q14,q7,q0,#8	@ X[i+1]
	vsli.64		q13,q6,#3
	veor		q15,q12
	vshr.u64	q12,q14,#1
	veor		q15,q13				@ sigma1(X[i+14])
	vshr.u64	q13,q14,#8
	vadd.i64	q7,q15
	vshr.u64	q15,q14,#7
	vsli.64		q12,q14,#63
	vsli.64		q13,q14,#56
	vext.8		q14,q3,q4,#8	@ X[i+9]
	veor		q15,q12
	vshr.u64	d24,d22,#14		@ from NEON_00_15
	vadd.i64	q7,q14
	vshr.u64	d25,d22,#18		@ from NEON_00_15
	veor		q15,q13				@ sigma0(X[i+1])
	vshr.u64	d26,d22,#41		@ from NEON_00_15
	vadd.i64	q7,q15
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d22,#50
	vsli.64		d25,d22,#46
	vsli.64		d26,d22,#23
#if 30<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d17
	veor		d29,d23,d16
	veor		d24,d25
	vand		d29,d22
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d16			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d18,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d18,#34
	vshr.u64	d26,d18,#39
	vsli.64		d24,d18,#36
	vsli.64		d25,d18,#30
	vsli.64		d26,d18,#25
	vadd.i64	d27,d14
	vorr		d30,d18,d20
	vand		d29,d18,d20
	veor		d17,d24,d25
	vand		d30,d19
	veor		d17,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d17,d27
	vadd.i64	d21,d27
	vadd.i64	d17,d30
	vshr.u64	d24,d21,#14	@ 31
#if 31<16
	vld1.64		{d15},[r1]!	@ handles unaligned
#endif
	vshr.u64	d25,d21,#18
	vshr.u64	d26,d21,#41
	vld1.64		{d28},[r3,:64]!	@ K[i++]
	vsli.64		d24,d21,#50
	vsli.64		d25,d21,#46
	vsli.64		d26,d21,#23
#if 31<16 && defined(__ARMEL__)
	vrev64.8	,
#endif
	vadd.i64	d27,d28,d16
	veor		d29,d22,d23
	veor		d24,d25
	vand		d29,d21
	veor		d24,d26			@ Sigma1(e)
	veor		d29,d23			@ Ch(e,f,g)
	vadd.i64	d27,d24
	vshr.u64	d24,d17,#28
	vadd.i64	d27,d29
	vshr.u64	d25,d17,#34
	vshr.u64	d26,d17,#39
	vsli.64		d24,d17,#36
	vsli.64		d25,d17,#30
	vsli.64		d26,d17,#25
	vadd.i64	d27,d15
	vorr		d30,d17,d19
	vand		d29,d17,d19
	veor		d16,d24,d25
	vand		d30,d18
	veor		d16,d26			@ Sigma0(a)
	vorr		d30,d29		@ Maj(a,b,c)
	vadd.i64	d16,d27
	vadd.i64	d20,d27
	vadd.i64	d16,d30
	bne		.L16_79_neon

	vldmia		r0,{d24-d31}	@ load context to temp
	vadd.i64	q8,q12		@ vectorized accumulate
	vadd.i64	q9,q13
	vadd.i64	q10,q14
	vadd.i64	q11,q15
	vstmia		r0,{d16-d23}	@ save context
	teq		r1,r2
	sub		r3,#640	@ rewind K512
	bne		.Loop_neon

	vldmia	sp!,{d8-d15}		@ epilogue
	bx	lr				@ .word	0xe12fff1e
#endif
.size	sha512_block_data_order,.-sha512_block_data_order
.asciz	"SHA512 block transform for ARMv4/NEON, CRYPTOGAMS by <appro@openssl.org>"
.align	2
.comm	OPENSSL_armcap_P,4,4
