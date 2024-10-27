// CuNNy 6x8 BILINEAR MPV NVL
// Copyright (c) 2024 cunnyplapper

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3.0 of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this program.  If not, see <https://www.gnu.org/licenses/>.
/* ------------------------------------------------------------------- */


//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-in
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable
#ifdef GL_EXT_shader_explicit_arithmetic_types_float16
#	define V4 f16vec4
#	define M4 f16mat4
#	define F float16_t
#else
#	define V4 vec4
#	define M4 mat4
#	define F float
#endif
#define l0(x, y) F(LUMA_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(1, 1) + ivec2(0, 0)) + vec2(0.5)) * LUMA_pt).r)
shared F G[1][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			G[0][ay][ax] = l0(x - 1, y - 1);
		}
	}
	barrier();
	F s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2;
	V4 r0, r1;
	r0 = V4(0.0); r1 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(4.358e-03, -2.470e-03, -8.342e-03, 4.503e-02) * s0_0_0;
	r1 += V4(-1.204e-02, -1.322e-02, -2.138e-02, -1.376e-02) * s0_0_0;
	r0 += V4(5.981e-01, 3.174e-01, 1.704e-01, 4.557e-01) * s0_0_1;
	r1 += V4(3.004e-01, 1.884e-02, 1.680e-02, 2.051e-01) * s0_0_1;
	r0 += V4(8.701e-02, -1.757e-01, -4.651e-02, 3.703e-02) * s0_0_2;
	r1 += V4(-5.065e-02, -7.623e-03, 6.116e-02, 3.565e-02) * s0_0_2;
	r0 += V4(2.875e-02, 7.251e-02, 7.188e-02, -4.286e-01) * s0_1_0;
	r1 += V4(2.499e-01, -7.036e-01, -2.021e-01, 3.666e-02) * s0_1_0;
	r0 += V4(-9.741e-02, 3.174e-01, 5.761e-01, -4.113e-02) * s0_1_1;
	r1 += V4(5.214e-01, 6.895e-01, 3.763e-01, -2.822e-01) * s0_1_1;
	r0 += V4(-6.192e-01, -5.371e-01, 2.607e-01, -2.199e-02) * s0_1_2;
	r1 += V4(3.190e-02, 2.202e-02, -2.013e-01, 3.521e-02) * s0_1_2;
	r0 += V4(-3.002e-02, -3.485e-02, 3.422e-02, -7.263e-02) * s0_2_0;
	r1 += V4(-5.183e-02, 2.037e-03, 2.251e-02, 2.102e-01) * s0_2_0;
	r0 += V4(-1.830e-03, 6.103e-02, -1.441e-02, 4.172e-02) * s0_2_1;
	r1 += V4(7.271e-04, -6.358e-03, 2.635e-02, -4.980e+00) * s0_2_1;
	r0 += V4(3.394e-02, -7.105e-04, -4.624e-02, -1.579e-02) * s0_2_2;
	r1 += V4(1.168e-02, -2.545e-03, 6.880e-03, -1.101e-01) * s0_2_2;
	r0 += V4(-1.382e-03, 2.735e-02, -2.347e-02, 3.182e-02);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(3.412e-02, -1.330e-03, 8.179e-02, 4.507e-02);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-conv1
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * in_pt)
#define l1(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * in_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1;
	vec4 f0, f1;
	r0 = ivec4(0); r1 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFC14FC11, 0x06EF1D02, 0x0010DFFC, 0x1706D90E);
	r1 = D(r1, s0_0_0, 0x01F1EA0E, 0xF32DDA15, 0x02C8F6FB, 0xF21FF807);
	r0 = D(r0, s0_0_1, 0xF80F1EEB, 0xFA2115FA, 0xFE00B510, 0xEE1DD709);
	r1 = D(r1, s0_0_1, 0xF9D8D70C, 0x092AD80D, 0xF8E3F009, 0x12E70EEE);
	r0 = D(r0, s0_0_2, 0x14140108, 0x06080EFB, 0x37FA11E0, 0xE2EEFF10);
	r1 = D(r1, s0_0_2, 0xE4F3F5F9, 0x13F60AF9, 0xFCE0FFFB, 0xFE0AFB0E);
	r0 = D(r0, s0_1_0, 0xFE25D80D, 0xF80EEB3A, 0x012A17D1, 0xF10C4319);
	r1 = D(r1, s0_1_0, 0x0D41FA16, 0x0309C706, 0x09F0151A, 0x07C2DC2A);
	r0 = D(r0, s0_1_1, 0xF75300ED, 0xFEE2E52F, 0x32FF29DD, 0xE5D6EC5D);
	r1 = D(r1, s0_1_1, 0xD222FE35, 0xFBD1F5FA, 0xCD0AEF08, 0xEA2DFE0D);
	r0 = D(r0, s0_1_2, 0x0011010F, 0x20DAF811, 0x0BEC2ABB, 0x190712F1);
	r1 = D(r1, s0_1_2, 0xEBB10FEE, 0x1A000602, 0xDFDEF7EC, 0xFBEEFF08);
	r0 = D(r0, s0_2_0, 0x090BE80F, 0x0B16112B, 0x19CF5485, 0x09095305);
	r1 = D(r1, s0_2_0, 0x1008E702, 0xE910CD07, 0xE1ED1306, 0x121C207F);
	r0 = D(r0, s0_2_1, 0x0D011408, 0xEB00AE20, 0x0EE5F5BD, 0xD5F1E6E6);
	r1 = D(r1, s0_2_1, 0x1023E917, 0x14F23213, 0x2F030118, 0x8ECCD258);
	r0 = D(r0, s0_2_2, 0xF021FF0A, 0x01E4F407, 0x27D127DE, 0x4707FBFC);
	r1 = D(r1, s0_2_2, 0xD8F2040A, 0xE632FD1B, 0x04FD09F4, 0xFF2615F8);
	r0 = D(r0, s1_0_0, 0xE00606FB, 0xF9F1060C, 0xD831F507, 0x271CF609);
	r1 = D(r1, s1_0_0, 0x02290007, 0x0CFB09F2, 0x03F2F714, 0x2904FCF2);
	r0 = D(r0, s1_0_1, 0xE00F16E1, 0x080E06F0, 0xF4A95011, 0xF4EC2A06);
	r1 = D(r1, s1_0_1, 0xE31A2103, 0x1B411EE2, 0xB5F9F92F, 0x210124ED);
	r0 = D(r0, s1_0_2, 0x14F9F6ED, 0x05F909F2, 0x0ED172FA, 0xFCF02E01);
	r1 = D(r1, s1_0_2, 0x21F6241D, 0xF5E317EF, 0xC40B0121, 0xE1EC13EA);
	r0 = D(r0, s1_1_0, 0x03E70BF7, 0xE246EEF8, 0xDDF7FDF1, 0xE049F8EF);
	r1 = D(r1, s1_1_0, 0x0BF2F8F8, 0x33E1122E, 0x02DDFF07, 0x04F01E0D);
	r0 = D(r0, s1_1_1, 0xF30E36F4, 0x01C45A0F, 0xE038EA41, 0xF8BF371B);
	r1 = D(r1, s1_1_1, 0xD44333F5, 0x28C62AF0, 0x0C30151E, 0x1C2C5905);
	r0 = D(r0, s1_1_2, 0x13F1FFDA, 0x02F57F1D, 0xADEBEB10, 0x10FB43F0);
	r1 = D(r1, s1_1_2, 0x14AB5C14, 0x070656F0, 0xF0FC2520, 0x21FFFF10);
	r0 = D(r0, s1_2_0, 0x0C04F9FC, 0xFDF0FEF6, 0x1021E804, 0x03F0F5EC);
	r1 = D(r1, s1_2_0, 0xFF0BF3FC, 0x04FA1C10, 0xECEC2310, 0x2F817F81);
	r0 = D(r0, s1_2_1, 0xF2FD02D8, 0x050E1223, 0x0221D008, 0x0232F804);
	r1 = D(r1, s1_2_1, 0xFEDE02E5, 0x16E91CD3, 0x2C062E06, 0x16455A81);
	r0 = D(r0, s1_2_2, 0x050BFC01, 0x050419F8, 0x04B809FF, 0x08DE0307);
	r1 = D(r1, s1_2_2, 0x12F30D0F, 0x021AFEFE, 0xED16EEF7, 0xF91021DD);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(7.842e-02, 9.205e-02, -3.232e-02, -3.190e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(4.817e-02, 1.033e-01, -1.827e-02, 2.940e-01);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-conv2
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv1_pt)
#define l1(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv1_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1;
	vec4 f0, f1;
	r0 = ivec4(0); r1 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x070BF20A, 0xDEE228FF, 0xFCEDFAED, 0x000803FF);
	r1 = D(r1, s0_0_0, 0x1B02EDE1, 0xF2DB0FE2, 0xE7FF20FF, 0xF4180F07);
	r0 = D(r0, s0_0_1, 0xFF1402FE, 0xDCFB23D5, 0x070FD3EE, 0x02031004);
	r1 = D(r1, s0_0_1, 0x2BFCE2DA, 0xF9EE0ABB, 0xFB0AF3DE, 0xCEF33BC3);
	r0 = D(r0, s0_0_2, 0x0202F503, 0xF4000309, 0x0803F407, 0x04FDF3FF);
	r1 = D(r1, s0_0_2, 0xFA10FE19, 0x18FCEAFE, 0xFFFFF9F8, 0x20B8D41D);
	r0 = D(r0, s0_1_0, 0xF60115F4, 0x16E3E5EE, 0x1BE81DA2, 0xFF081115);
	r1 = D(r1, s0_1_0, 0x2FE9E2DB, 0xF9F82109, 0x240FDBFF, 0x0F2B14FE);
	r0 = D(r0, s0_1_1, 0xEAE644E8, 0x3127C8F8, 0x06F405E3, 0xFCE4F53B);
	r1 = D(r1, s0_1_1, 0x3613BDF1, 0x0F2C2E11, 0xEBE235E9, 0x21C5B931);
	r0 = D(r0, s0_1_2, 0x06FDF1ED, 0x20EC0129, 0x10FDFA05, 0x1503FB12);
	r1 = D(r1, s0_1_2, 0xEE00180D, 0xF2011523, 0xF90301E0, 0xD916F4C8);
	r0 = D(r0, s0_2_0, 0xFB1D0AEE, 0xFBF3E1ED, 0xE5F50FCE, 0xFA090707);
	r1 = D(r1, s0_2_0, 0xE2061916, 0xF4020308, 0x21E2A93D, 0x0207F7EB);
	r0 = D(r0, s0_2_1, 0x09E0F5D9, 0xA6FBE3ED, 0x0A1B0120, 0x0DFE04F8);
	r1 = D(r1, s0_2_1, 0xEFFCEDFD, 0x1CE7C302, 0x1314F813, 0x23E70310);
	r0 = D(r0, s0_2_2, 0x0604FD1F, 0xFE1AD12D, 0xF7030A0E, 0x0101FAF8);
	r1 = D(r1, s0_2_2, 0xFC05FA36, 0x040D0A1D, 0xFA0A090C, 0x32FAC381);
	r0 = D(r0, s1_0_0, 0x0705FEF8, 0xFB0C0C27, 0x2FC01733, 0x03F8F902);
	r1 = D(r1, s1_0_0, 0xFE1AF7F8, 0x02F8DA0C, 0xEDF9FD0A, 0x28C50C14);
	r0 = D(r0, s1_0_1, 0x10F6EF04, 0x57DB1011, 0x7F123AFD, 0x0901FC05);
	r1 = D(r1, s1_0_1, 0x41D502FC, 0x15DC1DF2, 0x3A1D26ED, 0x40E50712);
	r0 = D(r0, s1_0_2, 0xEC1103FC, 0xA1DE1507, 0x7FD3FA09, 0x1D080903);
	r1 = D(r1, s1_0_2, 0x0428F8F2, 0xA5F50F00, 0xD2E9FBFE, 0x8181BC22);
	r0 = D(r0, s1_1_0, 0x08FEFC30, 0xF0F3FCAD, 0xFFC657FF, 0x10F80CFE);
	r1 = D(r1, s1_1_0, 0xFE0002ED, 0x02F4FCD6, 0xF6E3F2FF, 0x062504FE);
	r0 = D(r0, s1_1_1, 0x0D1006ED, 0x16F7EFDE, 0x149F1C04, 0x321EEE13);
	r1 = D(r1, s1_1_1, 0xC6D825B1, 0xFC243239, 0xC5EB40C3, 0x0A16F123);
	r0 = D(r0, s1_1_2, 0x1CF91D00, 0x17000001, 0xFECBF11C, 0x26FC0005);
	r1 = D(r1, s1_1_2, 0x412DF9F4, 0xFF09D501, 0x24EF0DF4, 0xF0EDE603);
	r0 = D(r0, s1_2_0, 0xFEF70EF6, 0x13210D42, 0x120E0051, 0x04FB01FA);
	r1 = D(r1, s1_2_0, 0x07FBF117, 0x040305F1, 0x1737C741, 0x0CEB1D09);
	r0 = D(r0, s1_2_1, 0x09EEFB02, 0xFE22FDD1, 0xFD1E0C10, 0x03FA22F0);
	r1 = D(r1, s1_2_1, 0xF400DB21, 0x030AFC10, 0xE72AE91D, 0x0716FE0F);
	r0 = D(r0, s1_2_2, 0x0213F8FD, 0xEE26221F, 0xFBF10201, 0x06FA02FF);
	r1 = D(r1, s1_2_2, 0xFFF50621, 0xF706F6F9, 0x02F000FD, 0xFE8162E6);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(4.210e-01, 1.358e-01, -4.469e-02, -2.447e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(1.254e-01, -2.896e-02, 4.496e-02, 8.820e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-conv3
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND conv2
//!BIND LUMA
//!SAVE conv3
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv2_pt)
#define l1(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv2_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1;
	vec4 f0, f1;
	r0 = ivec4(0); r1 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0400040E, 0x1404FDFE, 0x0303F902, 0x03FCFD06);
	r1 = D(r1, s0_0_0, 0xF9FB1306, 0xEA0810FC, 0xED000B06, 0x0903FBF1);
	r0 = D(r0, s0_0_1, 0x070A00F9, 0x0E08F6CB, 0xF7FDF8F3, 0xF3030CEC);
	r1 = D(r1, s0_0_1, 0xFB16FEF8, 0xE70DF4C6, 0x210BF8FA, 0x2E00FD06);
	r0 = D(r0, s0_0_2, 0x020AFF11, 0x14FC01EB, 0x0631E326, 0x0A02F90A);
	r1 = D(r1, s0_0_2, 0x00FC0106, 0x172AE126, 0x100CFF0F, 0x0210FE00);
	r0 = D(r0, s0_1_0, 0xC9040F1D, 0x04FCF3F2, 0x03070600, 0xFDFB02EE);
	r1 = D(r1, s0_1_0, 0x1E03EFCE, 0x1E12C2C0, 0x11011006, 0x0201EFF4);
	r0 = D(r0, s0_1_1, 0x251806DD, 0x540B0AA7, 0x110BFFCF, 0x4E0DF914);
	r1 = D(r1, s0_1_1, 0x32F6D007, 0xFD1194FD, 0xD010FDF0, 0xC9F2ED3B);
	r0 = D(r0, s0_1_2, 0xFE1AFFF3, 0x0C18F8F9, 0xF0160218, 0x14EBFC06);
	r1 = D(r1, s0_1_2, 0xE713FE17, 0x14991A61, 0x011DFB1D, 0x0408F40A);
	r0 = D(r0, s0_2_0, 0x04FFF8F6, 0xF40301F9, 0xF1FF0100, 0xEDFE0622);
	r1 = D(r1, s0_2_0, 0x1405E4F1, 0xF50AEA13, 0x02FDFFFC, 0x0A04FFFF);
	r0 = D(r0, s0_2_1, 0x0AFCFCFD, 0x0B04E707, 0x0002FF1D, 0xDA18F31E);
	r1 = D(r1, s0_2_1, 0xD7E9F935, 0xE1FE142D, 0xF805EE13, 0x02FE03FA);
	r0 = D(r0, s0_2_2, 0xFC05F907, 0x0D0009FF, 0x121800E3, 0x0F09EB04);
	r1 = D(r1, s0_2_2, 0xF93A1E03, 0x1BF826C7, 0x0DFA02F3, 0x020203F6);
	r0 = D(r0, s1_0_0, 0x01F106FE, 0xFB09FAFA, 0x32060001, 0xFA0806FA);
	r1 = D(r1, s1_0_0, 0x2703F706, 0x81F9FA07, 0x31F9FD06, 0x2607FEFE);
	r0 = D(r0, s1_0_1, 0xF704FFF8, 0x0E1502EB, 0x0E1CEC13, 0x1604F401);
	r1 = D(r1, s1_0_1, 0x1306FA11, 0x38E3EA08, 0x00FE0303, 0x0218FFFD);
	r0 = D(r0, s1_0_2, 0xFC00FF02, 0x011701FA, 0xFE2F050A, 0xFB050208);
	r1 = D(r1, s1_0_2, 0xFCF60901, 0xF9DC1EF4, 0x021AFFFF, 0xFD130102);
	r0 = D(r0, s1_1_0, 0x3FF5FC1A, 0x130C12FA, 0x02060704, 0x06F5030B);
	r1 = D(r1, s1_1_0, 0x200F08D8, 0xEBE2ED0D, 0x01FBEE11, 0x1F0D21F5);
	r0 = D(r0, s1_1_1, 0x0B251EF5, 0x140B0FD9, 0x0F001BF2, 0x200B07E9);
	r1 = D(r1, s1_1_1, 0xFF14F311, 0x57DFD8F5, 0x01F6240E, 0x0E3619ED);
	r0 = D(r0, s1_1_2, 0x001401F5, 0xF7FDFFFE, 0x0922FFDC, 0xFF09EAFE);
	r1 = D(r1, s1_1_2, 0x05E803EC, 0xFF061FB8, 0x040E0201, 0x0404FCFF);
	r0 = D(r0, s1_2_0, 0x03F825FE, 0x4A06FCFD, 0x1603F807, 0x28040407);
	r1 = D(r1, s1_2_0, 0x1FF7050A, 0xDE1344CD, 0xF5020501, 0x32FFFEFE);
	r0 = D(r0, s1_2_1, 0xF70808F8, 0xF80EF9EE, 0x1202EBFD, 0x1A1C0FEB);
	r1 = D(r1, s1_2_1, 0xEAE0DD19, 0x421D1CBE, 0x3B000206, 0x0502FC05);
	r0 = D(r0, s1_2_2, 0x02FD05FE, 0xFE0910FC, 0xF9090AF5, 0x000A00FE);
	r1 = D(r1, s1_2_2, 0x10070E00, 0x1A080AEB, 0xFDFAFB0E, 0xFD02FA0E);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(2.220e-02, -4.239e-01, -3.936e-02, -2.322e-01);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-6.282e-02, -7.379e-02, -2.838e-02, -7.355e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-conv4
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND conv3
//!BIND LUMA
//!SAVE conv4
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv3_pt)
#define l1(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv3_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1;
	vec4 f0, f1;
	r0 = ivec4(0); r1 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0BFE16F6, 0x00FDFCFE, 0xF5000B01, 0xF2072BFA);
	r1 = D(r1, s0_0_0, 0xF0F8F9FF, 0xF9F7150B, 0xFB0905FB, 0x0805E6FB);
	r0 = D(r0, s0_0_1, 0xE902F1E5, 0xF7FB0DFA, 0xE7FFEDDF, 0xE4FE0C04);
	r1 = D(r1, s0_0_1, 0xED0E16F7, 0xE00F08FE, 0xDE06F7EF, 0x1AFEEDF6);
	r0 = D(r0, s0_0_2, 0xF7FDF0FA, 0xEC000C01, 0xE6FC0318, 0xFEFCED0D);
	r1 = D(r1, s0_0_2, 0xF50923E5, 0x0BFBF105, 0xF8FF0003, 0xEC0E05FF);
	r0 = D(r0, s0_1_0, 0x432E2B02, 0x08F82CFE, 0xE7EAD40B, 0xFD1E3A07);
	r1 = D(r1, s0_1_0, 0xFB1E5703, 0x16F0FC08, 0x01120D04, 0x0514D301);
	r0 = D(r0, s0_1_1, 0x241B2DE0, 0x240A4908, 0x16C1CB39, 0x00CAF925);
	r1 = D(r1, s0_1_1, 0xCD197E03, 0xDE061C4D, 0x0DEDA30C, 0x0927BD0A);
	r0 = D(r0, s0_1_2, 0x1503EBF3, 0x02F51F1A, 0x02EB0B06, 0xF6FCEFFC);
	r1 = D(r1, s0_1_2, 0x310336CA, 0xE0F9FBFD, 0x24FC1021, 0x4CFC1F31);
	r0 = D(r0, s0_2_0, 0xFB03BBF4, 0xF7ED0E01, 0xEE22FC0F, 0xF41E0302);
	r1 = D(r1, s0_2_0, 0x01EF0D07, 0x0D011A06, 0xF70E0903, 0xF2FAF2FC);
	r0 = D(r0, s0_2_1, 0x180E16EC, 0x02F334F4, 0xFAFA3619, 0x04EFFA13);
	r1 = D(r1, s0_2_1, 0x0B1670EF, 0xFACC7F23, 0x00201C0A, 0xD84111F1);
	r0 = D(r0, s0_2_2, 0x0D010CFB, 0x03FE13F2, 0xFD030C0F, 0xEEE6F7F6);
	r1 = D(r1, s0_2_2, 0x01193AEC, 0xF0ED1BD9, 0x03090FFD, 0x050D02F2);
	r0 = D(r0, s1_0_0, 0xF50603D6, 0xFC130209, 0xF510F11A, 0xF60706FD);
	r1 = D(r1, s1_0_0, 0x0B051BF9, 0x05100103, 0xF603FB00, 0xFFFAF101);
	r0 = D(r0, s1_0_1, 0xF80406F9, 0xEE0B080C, 0xFA0E0527, 0xFFFB0C1C);
	r1 = D(r1, s1_0_1, 0x020717D2, 0xFFF70C06, 0x03FE0A03, 0xF8FE02F0);
	r0 = D(r0, s1_0_2, 0xF50FF906, 0x0BF70816, 0xFE02070B, 0x03F60319);
	r1 = D(r1, s1_0_2, 0xF4FD1C04, 0xFDFF0EFA, 0xFDF80801, 0x03EC0B05);
	r0 = D(r0, s1_1_0, 0x2C06FFE4, 0xED0DFF12, 0xF8FC3004, 0x15E9050B);
	r1 = D(r1, s1_1_0, 0xF9FBE2FD, 0x0A030DF1, 0x0EFFFC01, 0xFAE00D0D);
	r0 = D(r0, s1_1_1, 0xC016FFFC, 0xFABE1B1F, 0x0C1707F5, 0x2C18F04B);
	r1 = D(r1, s1_1_1, 0xEEE6FDF9, 0x2ACAFAD3, 0x3C320506, 0xF0042215);
	r0 = D(r0, s1_1_2, 0xFE08FAFD, 0x3DF4FB0D, 0x130B0A12, 0x010CEF0B);
	r1 = D(r1, s1_1_2, 0x46FD1F01, 0x0B0B0203, 0xFA08FD03, 0xF622FFF8);
	r0 = D(r0, s1_2_0, 0xFF0E14EC, 0x010D0102, 0x06F82011, 0x021E10FB);
	r1 = D(r1, s1_2_0, 0x07021101, 0x201C2500, 0xF9FB0100, 0xE507FC0D);
	r0 = D(r0, s1_2_1, 0x05B701F1, 0xFB1B03FE, 0xB3E01E1C, 0x02F2DCFE);
	r1 = D(r1, s1_2_1, 0xB30316F9, 0x81FD0D07, 0xF1F6FEFC, 0x0E47E50A);
	r0 = D(r0, s1_2_2, 0x21EAFAFF, 0x0BF9F904, 0xF2F5FE0A, 0xF0F9FA08);
	r1 = D(r1, s1_2_2, 0x01030706, 0xE712010B, 0xEFEC01F9, 0xE8E4EFF9);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(1.151e-02, -1.899e-02, -6.692e-03, -4.895e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(5.247e-02, 1.122e-02, -2.350e-02, -2.131e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-conv5
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND conv4
//!BIND LUMA
//!SAVE conv5
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv4_pt)
#define l1(x, y) conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv4_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1;
	vec4 f0, f1;
	r0 = ivec4(0); r1 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFD000702, 0xF6F80104, 0xF8FD1305, 0xD9081C06);
	r1 = D(r1, s0_0_0, 0x0BF9E202, 0xF7E8100B, 0x00000700, 0xE3F00813);
	r0 = D(r0, s0_0_1, 0xEDFF0009, 0xEC02010C, 0x060B0BFC, 0x15F11F0E);
	r1 = D(r1, s0_0_1, 0x2200E2EB, 0x08E3F804, 0xEF010502, 0xCF090328);
	r0 = D(r0, s0_0_2, 0x040B06FF, 0xFCF4FFFC, 0x00FA0314, 0x00F90805);
	r1 = D(r1, s0_0_2, 0x15F7E0E2, 0x10F3FCFF, 0x09FC0AFC, 0x17CA0205);
	r0 = D(r0, s0_1_0, 0xFBFD03FF, 0xF1FA0403, 0xF1F52104, 0x100523F9);
	r1 = D(r1, s0_1_0, 0x200BEBFE, 0xE5E5ED17, 0xF104040B, 0xFFF11FF3);
	r0 = D(r0, s0_1_1, 0xEA10F6FE, 0xF0FE27FC, 0x1D29D3DE, 0x08FEF60C);
	r1 = D(r1, s0_1_1, 0x16FBC73B, 0x0507EF24, 0xD614EAED, 0xFC0DFDBB);
	r0 = D(r0, s0_1_2, 0xF4F22742, 0xFBF3131B, 0xFFF0F0F0, 0x07F3FCF7);
	r1 = D(r1, s0_1_2, 0xE9E806E6, 0xF9050304, 0xF61E1EFF, 0xECBF1840);
	r0 = D(r0, s0_2_0, 0x020709FD, 0xFBFB08FE, 0x05FB0A00, 0x020309FD);
	r1 = D(r1, s0_2_0, 0xFA07040B, 0x00F435FD, 0xF3FD0EFF, 0x02F1ECFC);
	r0 = D(r0, s0_2_1, 0x02072CF6, 0xFE0501EF, 0xF7F8E60A, 0xFCFFFBF2);
	r1 = D(r1, s0_2_1, 0x0005F9FF, 0xFAF1DC0E, 0xF6290AF1, 0x090AF01D);
	r0 = D(r0, s0_2_2, 0x080506E7, 0xFBFAF800, 0x050406FB, 0x060005F9);
	r1 = D(r1, s0_2_2, 0xF608E908, 0x01E0F710, 0x0ED615FF, 0xFEE00BFF);
	r0 = D(r0, s1_0_0, 0xFB0403FC, 0xFE110205, 0xF61113F0, 0x041FF813);
	r1 = D(r1, s1_0_0, 0x11D7FA16, 0xE407F5EF, 0xF60C0E05, 0x09290301);
	r0 = D(r0, s1_0_1, 0xE604FAF8, 0xF428100A, 0x15F40612, 0xEA06E1ED);
	r1 = D(r1, s1_0_1, 0x27F94C21, 0x07000D02, 0xEE03E610, 0xCF11C3FA);
	r0 = D(r0, s1_0_2, 0x01041F0C, 0x00051003, 0x02F4F3F8, 0x00FB0103);
	r1 = D(r1, s1_0_2, 0x11F3FEFA, 0x02060103, 0xFDFC05FD, 0xF81E11F8);
	r0 = D(r0, s1_1_0, 0x030AFDF9, 0x0231050B, 0x2115EEFA, 0xFBD6FD09);
	r1 = D(r1, s1_1_0, 0xF8E511FC, 0xE570DDF9, 0x0216E802, 0xF91DF613);
	r0 = D(r0, s1_1_1, 0xEB5611FE, 0xF5C1120C, 0x0B07F600, 0xE538FF17);
	r1 = D(r1, s1_1_1, 0x31810C5C, 0xFAE7E006, 0xDB56F1D0, 0x14FBF0E9);
	r0 = D(r0, s1_1_2, 0xED13100A, 0xF50A0708, 0xFE040608, 0xFF0A0002);
	r1 = D(r1, s1_1_2, 0x07DFF91C, 0xFFF70105, 0xF91711E4, 0x07E111FD);
	r0 = D(r0, s1_2_0, 0xFCEFFCF9, 0xFB08FEFF, 0x05FF0903, 0x04F7FA05);
	r1 = D(r1, s1_2_0, 0x0506F710, 0xF9EBF715, 0x042308FF, 0x03F40DF8);
	r0 = D(r0, s1_2_1, 0xFF03FB08, 0x01FD0502, 0x01080609, 0xFC07FEFC);
	r1 = D(r1, s1_2_1, 0x17F7FA14, 0xE9420012, 0xFDCC0EED, 0x05FE0707);
	r0 = D(r0, s1_2_2, 0xEF1105FC, 0xFF0306FF, 0x01FC0400, 0x02FE0001);
	r1 = D(r1, s1_2_2, 0x04F7FD02, 0xFD190401, 0xF014FD06, 0xFC101404);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.167e-02, -1.617e-02, 1.849e-02, -2.153e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-8.967e-03, -2.020e-02, -2.574e-02, -8.043e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-conv6
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND conv5
//!BIND LUMA
//!SAVE conv6
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv5_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv5_pt)
#define l1(x, y) conv5_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv5_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1;
	vec4 f0, f1;
	r0 = ivec4(0); r1 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFE0821FF, 0x18F104ED, 0x090E0C26, 0xFE070702);
	r1 = D(r1, s0_0_0, 0x01FEFB0B, 0x0102FD04, 0x0004FC07, 0xFEFC0104);
	r0 = D(r0, s0_0_1, 0x030002F9, 0xE4F1E1EE, 0xEF0F0EFE, 0xF8FF05FF);
	r1 = D(r1, s0_0_1, 0xFB0014DB, 0xFF05150A, 0xF3F321D4, 0xFC08F9ED);
	r0 = D(r0, s0_0_2, 0xFCFEFB03, 0xF5E9E2F7, 0xFB030902, 0xFB030B04);
	r1 = D(r1, s0_0_2, 0xF3022EEE, 0xFDFF15F6, 0xFF0D24FA, 0x0500F2E5);
	r0 = D(r0, s0_1_0, 0xFDE7ACF6, 0xFFD10FD1, 0x0304F1F4, 0xFFFEF6EF);
	r1 = D(r1, s0_1_0, 0x04FDFF07, 0x0000FE14, 0x06030119, 0x06F6F7FE);
	r0 = D(r0, s0_1_1, 0x1F2B2D01, 0xEBE5F3E3, 0x7FD44CEE, 0x392BEEF5);
	r1 = D(r1, s0_1_1, 0x0305D51A, 0x00FACDC9, 0x30058127, 0x08EB0651);
	r0 = D(r0, s0_1_2, 0x04F5FFFE, 0x12EAECD6, 0xFB0607FE, 0x091820FD);
	r1 = D(r1, s0_1_2, 0x5A19E10F, 0x231B0F0D, 0x2B1832F9, 0x0CD0132C);
	r0 = D(r0, s0_2_0, 0x1E04F6FE, 0xF2EE08D5, 0xFA000C02, 0x01FF0006);
	r1 = D(r1, s0_2_0, 0x00000200, 0x01FF01FE, 0xF80200FF, 0xFC050902);
	r0 = D(r0, s0_2_1, 0x050521F2, 0x07D7C7EA, 0xFFFEFE01, 0x1A04EE0A);
	r1 = D(r1, s0_2_1, 0xFCFC03FC, 0x0901F80A, 0xF9FC0EF5, 0xF4F60DFC);
	r0 = D(r0, s0_2_2, 0x07FEFF01, 0x24CEFCDC, 0xF4FE0602, 0xF3020EFE);
	r1 = D(r1, s0_2_2, 0xE90017F3, 0x2D0622EA, 0xF5FD02FE, 0xC820A1ED);
	r0 = D(r0, s1_0_0, 0xFDE8FFE1, 0xF2FAFDFA, 0x052301FB, 0x060CFDFC);
	r1 = D(r1, s1_0_0, 0x01030003, 0xFFFF0102, 0x080506FF, 0x07070201);
	r0 = D(r0, s1_0_1, 0xF71214F8, 0xFFEEFFDB, 0xF100D3F2, 0x07FDF8F7);
	r1 = D(r1, s1_0_1, 0x14FFF9DD, 0x01ECFCEA, 0x252AF2BA, 0x08FEFC02);
	r0 = D(r0, s1_0_2, 0x0000FD04, 0xF6DF0407, 0xFE0517FC, 0xF306E4FA);
	r1 = D(r1, s1_0_2, 0x014F34C1, 0xF3190DE6, 0xE81A4BDC, 0x15F9350C);
	r0 = D(r0, s1_1_0, 0x2851E098, 0xDF25F0F1, 0x180505F3, 0x0B0701F2);
	r1 = D(r1, s1_1_0, 0x02FD0201, 0x03070004, 0x02FA0204, 0xF5F80107);
	r0 = D(r0, s1_1_1, 0xF9F142BB, 0x0B0110D8, 0x0DFD05F5, 0x0F070914);
	r1 = D(r1, s1_1_1, 0xD0FFFBEB, 0x071EEAD3, 0xD504E1C0, 0xE9161813);
	r0 = D(r0, s1_1_2, 0x0408EF03, 0xF904FE03, 0x07FF10FE, 0x090014F3);
	r1 = D(r1, s1_1_2, 0x22EAE1BE, 0x2D3C2CE3, 0x12EAF7E2, 0xA5FBD8E1);
	r0 = D(r0, s1_2_0, 0xF0FB00F8, 0xF41AFCD4, 0x0202FF00, 0x05030200);
	r1 = D(r1, s1_2_0, 0x0103FF02, 0x02030100, 0x0103FE00, 0x04FCFD02);
	r0 = D(r0, s1_2_1, 0x0C03FEF9, 0xFDF70DEA, 0xF701FE05, 0xF3FFFAF2);
	r1 = D(r1, s1_2_1, 0x0A02FF04, 0xF20000FA, 0x1401030B, 0x140609EF);
	r0 = D(r0, s1_2_2, 0x00FFFD00, 0xF119F9FA, 0xFAFEFDFC, 0x02FBFAF8);
	r1 = D(r1, s1_2_2, 0x0A040802, 0x14FFF8F4, 0x010307FF, 0x3C01F781);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-5.229e-03, -5.919e-02, 1.107e-02, -3.261e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-5.478e-03, -4.684e-03, -6.075e-03, -5.033e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-6x8-BILINEAR-MPV-NVL-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv6
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable
#ifdef GL_EXT_shader_explicit_arithmetic_types_float16
#	define V4 f16vec4
#	define M4 f16mat4
#	define F float16_t
#else
#	define V4 vec4
#	define M4 mat4
#	define F float
#endif
#define l0(x, y) V4(conv6_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv6_pt))
#define l1(x, y) V4(conv6_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv6_pt))
shared V4 G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			G[0][ay][ax] = l0(x - 1, y - 1);
			G[1][ay][ax] = l1(x - 1, y - 1);
		}
	}
	barrier();
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	V4 r0;
	r0 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 += M4(-1.807e-04, -3.945e-03, -8.082e-03, -4.035e-03, 3.935e-01, -1.061e-01, 1.730e-02, -4.027e-01, 1.345e-02, -3.031e-03, -2.604e-04, 3.121e-04, -8.521e-02, 3.186e-04, 1.010e-02, -1.391e-03) * s0_0_0;
	r0 += M4(9.305e-02, -4.279e-02, -3.715e-02, 5.400e-04, -1.796e-01, 6.432e-01, 3.410e-02, 2.370e-01, 8.086e-03, 8.839e-03, -1.477e-02, -1.642e-02, -1.999e-01, -2.601e-01, 4.206e-02, 6.421e-02) * s0_0_1;
	r0 += M4(1.181e-01, 6.958e-02, -3.528e-02, -2.265e-03, 1.808e-01, -6.246e-02, -6.846e-03, -4.942e-02, -1.202e-02, 3.532e-03, 4.682e-03, 1.702e-03, 1.889e-03, -1.759e-02, 1.862e-02, 2.152e-02) * s0_0_2;
	r0 += M4(-3.671e-03, -3.852e-03, -2.380e-03, -3.960e-03, 6.300e-02, -2.141e-02, 1.994e-01, 1.074e-01, -2.152e-02, -8.898e-04, -3.877e-03, -2.000e-03, -7.475e-03, 1.668e-02, -8.712e-02, 1.174e-02) * s0_1_0;
	r0 += M4(1.256e-01, -4.296e-02, 3.086e-01, -3.826e-02, -2.418e-01, -1.111e-01, 1.044e-01, 1.944e-01, 3.845e-01, 5.662e-02, 1.931e-01, 7.402e-02, -2.572e-01, -2.845e-01, -5.195e-01, -6.977e-01) * s0_1_1;
	r0 += M4(1.479e-01, 6.601e-02, 1.763e-01, -6.987e-01, 1.254e-02, 2.197e-01, 1.341e-01, 1.281e-01, 1.020e-02, 3.096e-01, 3.919e-04, 1.302e-01, 5.035e-02, 1.752e-02, 2.456e-02, 3.191e-02) * s0_1_2;
	r0 += M4(-2.570e-03, 1.040e-03, -7.055e-03, -1.744e-03, 1.463e-01, -2.346e-01, -3.969e-01, -6.160e-02, 3.307e-03, 2.792e-03, -3.471e-03, 1.428e-03, 3.436e-03, -6.741e-03, 2.423e-02, -2.736e-03) * s0_2_0;
	r0 += M4(7.425e-03, -2.775e-03, -1.268e-02, -1.294e-03, -9.054e-02, 1.374e-01, -4.078e-01, 1.347e-01, 6.538e-03, 1.957e-04, 1.852e-01, 3.807e-03, 2.362e-02, 3.537e-02, 4.401e-02, 6.457e-02) * s0_2_1;
	r0 += M4(4.866e-03, -6.724e-04, -9.800e-03, 2.798e-03, 1.541e-01, 1.599e-01, 8.652e-03, 1.220e-01, -2.522e-02, -1.613e-02, -2.310e-02, 1.587e-01, -1.865e-03, -8.358e-03, 6.397e-03, -5.317e-03) * s0_2_2;
	r0 += M4(6.372e-02, 3.161e-02, -1.362e-02, 3.816e-03, 2.658e-02, 1.733e-01, 1.472e-02, -8.362e-03, -1.615e-02, -1.185e-02, -3.045e-02, -1.689e-02, 4.406e-01, 2.256e-01, -1.815e-01, -2.429e-01) * s1_0_0;
	r0 += M4(-2.062e-03, -2.449e-02, 4.817e-03, -8.188e-03, 5.533e-02, 3.518e-02, 2.197e-03, -5.114e-02, 2.789e-02, 7.150e-02, -1.832e-02, -1.898e-02, -4.833e-02, 1.184e-01, -3.157e-03, 1.438e-02) * s1_0_1;
	r0 += M4(-8.882e-04, -5.436e-04, -3.567e-04, -3.390e-03, -6.867e-04, 4.981e-04, -8.262e-03, -7.059e-04, 2.917e-03, 1.399e-02, -4.726e-03, -1.117e-02, 8.785e-03, 3.708e-04, 1.110e-02, -2.666e-02) * s1_0_2;
	r0 += M4(-8.699e-01, 1.766e-01, 1.609e-01, 1.751e-01, -9.499e-02, 1.733e-01, -9.019e-01, 3.143e-01, 7.354e-02, -3.290e-02, 1.765e-01, -3.750e-02, -6.104e-02, -4.989e-02, 8.032e-02, 7.097e-02) * s1_1_0;
	r0 += M4(3.835e-03, 3.483e-02, -9.942e-03, 1.919e-01, 2.108e-02, -2.224e-02, 9.155e-02, -2.011e-01, 1.814e-02, -8.892e-01, 1.840e-01, 1.674e-01, 1.386e-02, 1.630e-03, -3.489e-03, 1.504e-02) * s1_1_1;
	r0 += M4(9.340e-03, -9.189e-03, 1.279e-02, -9.433e-03, -5.288e-03, 8.014e-03, -7.227e-03, 7.903e-03, -3.479e-02, -4.178e-03, -1.947e-02, 1.505e-02, 1.111e-03, -2.532e-03, 3.266e-03, -1.078e-02) * s1_1_2;
	r0 += M4(3.798e-02, 1.437e-02, 1.284e-01, 1.175e-01, -1.167e-02, 2.940e-03, -9.307e-03, -6.678e-03, 4.532e-03, -1.868e-02, 7.114e-02, -3.406e-02, -3.813e-03, -3.516e-03, -4.171e-03, -4.095e-03) * s1_2_0;
	r0 += M4(-4.425e-03, -1.213e-02, -1.797e-02, 1.250e-01, 3.096e-03, -4.425e-03, 3.290e-03, -8.093e-03, 3.978e-02, 7.878e-02, 6.901e-02, 6.220e-02, -7.749e-03, -1.863e-03, -3.018e-03, 2.618e-03) * s1_2_1;
	r0 += M4(3.542e-03, -1.049e-02, 9.952e-03, -3.437e-03, 5.456e-04, 7.475e-03, -3.509e-03, 9.030e-03, -5.654e-03, 1.268e-02, -6.067e-03, -3.458e-02, -2.205e-03, -7.418e-03, -4.137e-03, -8.575e-03) * s1_2_2;
	r0 += V4(-2.903e-08, -1.714e-08, -3.040e-08, -3.019e-08);
	r0 = tanh(r0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
