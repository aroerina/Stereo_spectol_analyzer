/**
*	ユーザー定義ファイル
*	Copyleft Junnichi Tomaru
*	version 2011.08.03
*/
#define OUT(data,port)	__builtin_export(data,port)
#define IN(port)		__builtin_import(port)
#define ITR_OFF			asm("clri")	//割り込み禁止
#define ITR_ON			asm("seti")	//割り込み許可

#define BS(x,y)		x|=y	// Bit Set
#define BC(x,y)		x&=~y	// Bit Clear

/* --------- 文字コード定義 --------- */
#define		C_SOH	0x01
#define		C_STX	0x02
#define		C_ETX	0x03
#define		C_EOT	0x04
#define		C_ENQ	0x05
#define		C_ACK	0x06
#define		C_BEL	0x07
#define		C_BS	0x08
#define		C_HT	0x09
#define		C_LF	0x0A
#define		C_VT	0x0B
#define		C_FF	0x0C
#define		C_CR	0x0D
#define		C_SO	0x0E
#define		C_SI	0x0F
#define		C_DLE	0x10
#define		C_DC1	0x11
#define		C_DC2	0x12
#define		C_DC3	0x13
#define		C_DC4	0x14
#define		C_NAK	0x15
#define		C_SYN	0x16
#define		C_ETB	0x17
#define		C_CAN	0x18
#define		C_EM	0x19
#define		C_SUB	0x1A
#define		C_ESC	0x1B
#define		C_FS	0x1C
#define		C_GS	0x1D
#define		C_RS	0x1E
#define		C_US	0x1F

/* ---------- TRUE/FALSE ---------- */
#define		FALSE	0
#define		TRUE	1

/* ---------- 型定義 ---------- */
#ifndef		_INTEGER_DEFINED
typedef		unsigned char	bool;
typedef		unsigned char	byte;
typedef		unsigned int	uint;
typedef		unsigned short	word;
typedef		unsigned long	dword;
#define		_INTEGER_DEFINED
#endif

#ifndef		_BITDEF_DEFINED
/* ---------- ビット定義 ---------- */
/* 8bit */
#define		BB_0		0x01
#define		BB_1		0x02
#define		BB_2		0x04
#define		BB_3		0x08
#define		BB_4		0x10
#define		BB_5		0x20
#define		BB_6		0x40
#define		BB_7		0x80

#define		BB_0MASK	0xfe
#define		BB_1MASK	0xfd
#define		BB_2MASK	0xfb
#define		BB_3MASK	0xf7
#define		BB_4MASK	0xef
#define		BB_5MASK	0xdf
#define		BB_6MASK	0xbf
#define		BB_7MASK	0x7f

/* 16bit */
#define		WB_00		0x0001
#define		WB_01		0x0002
#define		WB_02		0x0004
#define		WB_03		0x0008
#define		WB_04		0x0010
#define		WB_05		0x0020
#define		WB_06		0x0040
#define		WB_07		0x0080
#define		WB_08		0x0100
#define		WB_09		0x0200
#define		WB_10		0x0400
#define		WB_11		0x0800
#define		WB_12		0x1000
#define		WB_13		0x2000
#define		WB_14		0x4000
#define		WB_15		0x8000

#define		WB_00MASK	0xfffe
#define		WB_01MASK	0xfffd
#define		WB_02MASK	0xfffb
#define		WB_03MASK	0xfff7
#define		WB_04MASK	0xffef
#define		WB_05MASK	0xffdf
#define		WB_06MASK	0xffbf
#define		WB_07MASK	0xff7f
#define		WB_08MASK	0xfeff
#define		WB_09MASK	0xfdff
#define		WB_10MASK	0xfbff
#define		WB_11MASK	0xf7ff
#define		WB_12MASK	0xefff
#define		WB_13MASK	0xdfff
#define		WB_14MASK	0xbfff
#define		WB_15MASK	0x7fff

/* 32bit */
#define		LB_00		0x00000001
#define		LB_01		0x00000002
#define		LB_02		0x00000004
#define		LB_03		0x00000008
#define		LB_04		0x00000010
#define		LB_05		0x00000020
#define		LB_06		0x00000040
#define		LB_07		0x00000080
#define		LB_08		0x00000100
#define		LB_09		0x00000200
#define		LB_10		0x00000400
#define		LB_11		0x00000800
#define		LB_12		0x00001000
#define		LB_13		0x00002000
#define		LB_14		0x00004000
#define		LB_15		0x00008000
#define		LB_16		0x00010000
#define		LB_17		0x00020000
#define		LB_18		0x00040000
#define		LB_19		0x00080000
#define		LB_20		0x00100000
#define		LB_21		0x00200000
#define		LB_22		0x00400000
#define		LB_23		0x00800000
#define		LB_24		0x01000000
#define		LB_25		0x02000000
#define		LB_26		0x04000000
#define		LB_27		0x08000000
#define		LB_28		0x10000000
#define		LB_29		0x20000000
#define		LB_30		0x40000000
#define		LB_31		0x80000000

#define		LB_00MASK	0xfffffffe
#define		LB_01MASK	0xfffffffd
#define		LB_02MASK	0xfffffffb
#define		LB_03MASK	0xfffffff7
#define		LB_04MASK	0xffffffef
#define		LB_05MASK	0xffffffdf
#define		LB_06MASK	0xffffffbf
#define		LB_07MASK	0xffffff7f
#define		LB_08MASK	0xfffffeff
#define		LB_09MASK	0xfffffdff
#define		LB_10MASK	0xfffffbff
#define		LB_11MASK	0xfffff7ff
#define		LB_12MASK	0xffffefff
#define		LB_13MASK	0xffffdfff
#define		LB_14MASK	0xffffbfff
#define		LB_15MASK	0xffff7fff
#define		LB_16MASK	0xfffeffff
#define		LB_17MASK	0xfffdffff
#define		LB_18MASK	0xfffbffff
#define		LB_19MASK	0xfff7ffff
#define		LB_20MASK	0xffefffff
#define		LB_21MASK	0xffdfffff
#define		LB_22MASK	0xffbfffff
#define		LB_23MASK	0xff7fffff
#define		LB_24MASK	0xfeffffff
#define		LB_25MASK	0xfdffffff
#define		LB_26MASK	0xfbffffff
#define		LB_27MASK	0xf7ffffff
#define		LB_28MASK	0xefffffff
#define		LB_29MASK	0xdfffffff
#define		LB_30MASK	0xbfffffff
#define		LB_31MASK	0x7fffffff

/* ---------- ビット制御 ---------- */
/* 8bit */
#define		BB0_ON(x)	x|=0x01
#define		BB1_ON(x)	x|=0x02
#define		BB2_ON(x)	x|=0x04
#define		BB3_ON(x)	x|=0x08
#define		BB4_ON(x)	x|=0x10
#define		BB5_ON(x)	x|=0x20
#define		BB6_ON(x)	x|=0x40
#define		BB7_ON(x)	x|=0x80

#define		BB0_OFF(x)	x&=0xfe
#define		BB1_OFF(x)	x&=0xfd
#define		BB2_OFF(x)	x&=0xfb
#define		BB3_OFF(x)	x&=0xf7
#define		BB4_OFF(x)	x&=0xef
#define		BB5_OFF(x)	x&=0xdf
#define		BB6_OFF(x)	x&=0xbf
#define		BB7_OFF(x)	x&=0x7f

#define		BB0_INV(x)	x^=0x01
#define		BB1_INV(x)	x^=0x02
#define		BB2_INV(x)	x^=0x04
#define		BB3_INV(x)	x^=0x08
#define		BB4_INV(x)	x^=0x10
#define		BB5_INV(x)	x^=0x20
#define		BB6_INV(x)	x^=0x40
#define		BB7_INV(x)	x^=0x80

/* 16bit */
#define		WB00_ON(x)	x|=0x0001
#define		WB01_ON(x)	x|=0x0002
#define		WB02_ON(x)	x|=0x0004
#define		WB03_ON(x)	x|=0x0008
#define		WB04_ON(x)	x|=0x0010
#define		WB05_ON(x)	x|=0x0020
#define		WB06_ON(x)	x|=0x0040
#define		WB07_ON(x)	x|=0x0080
#define		WB08_ON(x)	x|=0x0100
#define		WB09_ON(x)	x|=0x0200
#define		WB10_ON(x)	x|=0x0400
#define		WB11_ON(x)	x|=0x0800
#define		WB12_ON(x)	x|=0x1000
#define		WB13_ON(x)	x|=0x2000
#define		WB14_ON(x)	x|=0x4000
#define		WB15_ON(x)	x|=0x8000

#define		WB00_OFF(x)	x&=0xfffe
#define		WB01_OFF(x)	x&=0xfffd
#define		WB02_OFF(x)	x&=0xfffb
#define		WB03_OFF(x)	x&=0xfff7
#define		WB04_OFF(x)	x&=0xffef
#define		WB05_OFF(x)	x&=0xffdf
#define		WB06_OFF(x)	x&=0xffbf
#define		WB07_OFF(x)	x&=0xff7f
#define		WB08_OFF(x)	x&=0xfeff
#define		WB09_OFF(x)	x&=0xfdff
#define		WB10_OFF(x)	x&=0xfbff
#define		WB11_OFF(x)	x&=0xf7ff
#define		WB12_OFF(x)	x&=0xefff
#define		WB13_OFF(x)	x&=0xdfff
#define		WB14_OFF(x)	x&=0xbfff
#define		WB15_OFF(x)	x&=0x7fff

#define		WB00_INV(x)	x^=0x0001
#define		WB01_INV(x)	x^=0x0002
#define		WB02_INV(x)	x^=0x0004
#define		WB03_INV(x)	x^=0x0008
#define		WB04_INV(x)	x^=0x0010
#define		WB05_INV(x)	x^=0x0020
#define		WB06_INV(x)	x^=0x0040
#define		WB07_INV(x)	x^=0x0080
#define		WB08_INV(x)	x^=0x0100
#define		WB09_INV(x)	x^=0x0200
#define		WB10_INV(x)	x^=0x0400
#define		WB11_INV(x)	x^=0x0800
#define		WB12_INV(x)	x^=0x1000
#define		WB13_INV(x)	x^=0x2000
#define		WB14_INV(x)	x^=0x4000
#define		WB15_INV(x)	x^=0x8000

/* 32bit */
#define		LB00_ON(x)	x|=0x00000001
#define		LB01_ON(x)	x|=0x00000002
#define		LB02_ON(x)	x|=0x00000004
#define		LB03_ON(x)	x|=0x00000008
#define		LB04_ON(x)	x|=0x00000010
#define		LB05_ON(x)	x|=0x00000020
#define		LB06_ON(x)	x|=0x00000040
#define		LB07_ON(x)	x|=0x00000080
#define		LB08_ON(x)	x|=0x00000100
#define		LB09_ON(x)	x|=0x00000200
#define		LB10_ON(x)	x|=0x00000400
#define		LB11_ON(x)	x|=0x00000800
#define		LB12_ON(x)	x|=0x00001000
#define		LB13_ON(x)	x|=0x00002000
#define		LB14_ON(x)	x|=0x00004000
#define		LB15_ON(x)	x|=0x00008000
#define		LB16_ON(x)	x|=0x00010000
#define		LB17_ON(x)	x|=0x00020000
#define		LB18_ON(x)	x|=0x00040000
#define		LB19_ON(x)	x|=0x00080000
#define		LB20_ON(x)	x|=0x00100000
#define		LB21_ON(x)	x|=0x00200000
#define		LB22_ON(x)	x|=0x00400000
#define		LB23_ON(x)	x|=0x00800000
#define		LB24_ON(x)	x|=0x01000000
#define		LB25_ON(x)	x|=0x02000000
#define		LB26_ON(x)	x|=0x04000000
#define		LB27_ON(x)	x|=0x08000000
#define		LB28_ON(x)	x|=0x10000000
#define		LB29_ON(x)	x|=0x20000000
#define		LB30_ON(x)	x|=0x40000000
#define		LB31_ON(x)	x|=0x80000000

#define		LB00_OFF(x)	x&=0xfffffffe
#define		LB01_OFF(x)	x&=0xfffffffd
#define		LB02_OFF(x)	x&=0xfffffffb
#define		LB03_OFF(x)	x&=0xfffffff7
#define		LB04_OFF(x)	x&=0xffffffef
#define		LB05_OFF(x)	x&=0xffffffdf
#define		LB06_OFF(x)	x&=0xffffffbf
#define		LB07_OFF(x)	x&=0xffffff7f
#define		LB08_OFF(x)	x&=0xfffffeff
#define		LB09_OFF(x)	x&=0xfffffdff
#define		LB10_OFF(x)	x&=0xfffffbff
#define		LB11_OFF(x)	x&=0xfffff7ff
#define		LB12_OFF(x)	x&=0xffffefff
#define		LB13_OFF(x)	x&=0xffffdfff
#define		LB14_OFF(x)	x&=0xffffbfff
#define		LB15_OFF(x)	x&=0xffff7fff
#define		LB16_OFF(x)	x&=0xfffeffff
#define		LB17_OFF(x)	x&=0xfffdffff
#define		LB18_OFF(x)	x&=0xfffbffff
#define		LB19_OFF(x)	x&=0xfff7ffff
#define		LB20_OFF(x)	x&=0xffefffff
#define		LB21_OFF(x)	x&=0xffdfffff
#define		LB22_OFF(x)	x&=0xffbfffff
#define		LB23_OFF(x)	x&=0xff7fffff
#define		LB24_OFF(x)	x&=0xfeffffff
#define		LB25_OFF(x)	x&=0xfdffffff
#define		LB26_OFF(x)	x&=0xfbffffff
#define		LB27_OFF(x)	x&=0xf7ffffff
#define		LB28_OFF(x)	x&=0xefffffff
#define		LB29_OFF(x)	x&=0xdfffffff
#define		LB30_OFF(x)	x&=0xbfffffff
#define		LB31_OFF(x)	x&=0x7fffffff

#define		LB00_INV(x)	x^=0x00000001
#define		LB01_INV(x)	x^=0x00000002
#define		LB02_INV(x)	x^=0x00000004
#define		LB03_INV(x)	x^=0x00000008
#define		LB04_INV(x)	x^=0x00000010
#define		LB05_INV(x)	x^=0x00000020
#define		LB06_INV(x)	x^=0x00000040
#define		LB07_INV(x)	x^=0x00000080
#define		LB08_INV(x)	x^=0x00000100
#define		LB09_INV(x)	x^=0x00000200
#define		LB10_INV(x)	x^=0x00000400
#define		LB11_INV(x)	x^=0x00000800
#define		LB12_INV(x)	x^=0x00001000
#define		LB13_INV(x)	x^=0x00002000
#define		LB14_INV(x)	x^=0x00004000
#define		LB15_INV(x)	x^=0x00008000
#define		LB16_INV(x)	x^=0x00010000
#define		LB17_INV(x)	x^=0x00020000
#define		LB18_INV(x)	x^=0x00040000
#define		LB19_INV(x)	x^=0x00080000
#define		LB20_INV(x)	x^=0x00100000
#define		LB21_INV(x)	x^=0x00200000
#define		LB22_INV(x)	x^=0x00400000
#define		LB23_INV(x)	x^=0x00800000
#define		LB24_INV(x)	x^=0x01000000
#define		LB25_INV(x)	x^=0x02000000
#define		LB26_INV(x)	x^=0x04000000
#define		LB27_INV(x)	x^=0x08000000
#define		LB28_INV(x)	x^=0x10000000
#define		LB29_INV(x)	x^=0x20000000
#define		LB30_INV(x)	x^=0x40000000
#define		LB31_INV(x)	x^=0x80000000
#define		_BITDEF_DEFINED
#endif

#ifndef		_BOOL_DEFINED
typedef	enum { off, on }	swbool;
typedef	enum { low, high }	levelbool;
#define		_BOOL_DEFINED
#endif

/* 制御構造 */
#define		_loop(n)	{i=0;for(i=0;i<(n);i++){
#define		_endloop	}}
#define		_repeat		do
#define		_until(n)	while(!(n))
#define		_case		break; case
#define		_default	break; default
#define		_or		: case
#define		_forever	for(;;)

/* 外部定義用 */
#if defined(_GLOBAL_DEFINED)
#define		_Extern
#else
#define		_Extern		extern
#endif

/* 関数マクロ */
#define		_abs(ver)	(((ver) >= 0) ? (ver) : (-(ver)))


/* end of userdef.h */
