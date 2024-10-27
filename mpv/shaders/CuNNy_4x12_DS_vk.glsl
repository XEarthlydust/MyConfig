// CuNNy 4x12 BILINEAR MPV NVL
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


//!DESC CuNNy-4x12-BILINEAR-MPV-NVL-in
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 3 *
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
	ivec2 opos = pos * ivec2(3, 1);
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
	V4 r0, r1, r2;
	r0 = V4(0.0); r1 = V4(0.0); r2 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(-2.157e-03, -1.751e-02, -2.103e-02, 2.564e-02) * s0_0_0;
	r1 += V4(2.522e-02, -1.721e-01, -1.257e-02, 4.036e-02) * s0_0_0;
	r2 += V4(4.781e-02, 4.613e-02, 4.335e-03, -6.186e-02) * s0_0_0;
	r0 += V4(7.966e-02, -6.585e-01, 8.755e-02, -2.624e-03) * s0_0_1;
	r1 += V4(-2.337e-02, -2.675e-02, -3.845e-02, 7.474e-02) * s0_0_1;
	r2 += V4(-3.303e-02, 6.445e-02, 1.812e-02, 2.163e-02) * s0_0_1;
	r0 += V4(1.826e-02, -7.863e-03, -6.567e-02, -2.989e-02) * s0_0_2;
	r1 += V4(-9.642e-03, -6.238e-02, -8.221e-02, 3.551e-02) * s0_0_2;
	r2 += V4(-1.278e-02, 2.928e-03, -2.775e-02, 3.674e-02) * s0_0_2;
	r0 += V4(-5.785e+00, 3.162e-02, 1.617e-02, 5.480e-03) * s0_1_0;
	r1 += V4(-3.745e-02, -2.670e-01, 2.145e-02, 1.182e-01) * s0_1_0;
	r2 += V4(3.188e-02, -1.354e-02, -6.421e-02, 5.786e-01) * s0_1_0;
	r0 += V4(-4.150e-01, 6.309e-01, 6.074e-01, -2.063e-02) * s0_1_1;
	r1 += V4(-7.402e-01, 4.327e-01, 4.795e-01, 2.173e-01) * s0_1_1;
	r2 += V4(-5.043e-01, -1.120e+00, 6.827e-01, -4.658e-01) * s0_1_1;
	r0 += V4(1.129e-01, 2.561e-02, -6.203e-01, -6.340e-03) * s0_1_2;
	r1 += V4(2.102e-01, 1.447e-01, -1.435e-01, -8.153e-02) * s0_1_2;
	r2 += V4(-9.687e-02, 7.271e-02, 5.901e-02, -7.894e-02) * s0_1_2;
	r0 += V4(3.961e-02, -1.490e-02, 7.895e-03, -4.684e-02) * s0_2_0;
	r1 += V4(7.988e-04, -5.172e-02, -1.457e-02, -5.088e-03) * s0_2_0;
	r2 += V4(3.228e-01, 7.184e-02, -2.687e-01, -9.555e-02) * s0_2_0;
	r0 += V4(1.165e-01, 3.479e-02, 1.510e-01, 5.901e-01) * s0_2_1;
	r1 += V4(1.185e-01, 2.256e-02, -8.850e-03, 1.399e-01) * s0_2_1;
	r2 += V4(1.456e-01, -1.505e+00, -3.598e-01, 3.367e-02) * s0_2_1;
	r0 += V4(6.145e-03, -1.762e-02, -1.637e-01, -5.020e-01) * s0_2_2;
	r1 += V4(4.562e-01, -1.730e-02, -1.470e-01, 3.291e-02) * s0_2_2;
	r2 += V4(1.007e-01, 7.702e-02, -4.064e-02, 3.374e-02) * s0_2_2;
	r0 += V4(6.455e-02, -5.132e-03, 1.360e-02, -2.366e-02);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-2.141e-03, 9.650e-03, 2.577e-03, -2.359e-02);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(1.035e-02, 8.120e-02, -3.262e-03, -1.885e-03);
	r2 = max(r2, V4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), vec4(r2));
}

//!DESC CuNNy-4x12-BILINEAR-MPV-NVL-conv1
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * in_pt)
#define l1(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * in_pt)
#define l2(x, y) in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * in_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[3][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(3, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2;
	vec4 f0, f1, f2;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xBE4A04FB, 0xD438190B, 0xF60C010D, 0xDFEB020A);
	r1 = D(r1, s0_0_0, 0x44F1001A, 0xDD300604, 0x4AFA04FC, 0x1F2B0404);
	r2 = D(r2, s0_0_0, 0x021305FC, 0xC812FC0C, 0x13EEF901, 0xC9C3F715);
	r0 = D(r0, s0_0_1, 0xF2E6F7E6, 0xD4F2EAE3, 0x351C10F6, 0xEAE80618);
	r1 = D(r1, s0_0_1, 0x3BDCED06, 0x14F407E9, 0x81F000F5, 0xD811FE1A);
	r2 = D(r2, s0_0_1, 0xE2120D04, 0xEFF3F711, 0x12F6140A, 0xF50907F0);
	r0 = D(r0, s0_0_2, 0xFAFFF4DD, 0x08011FF9, 0xF30A0108, 0x07F50915);
	r1 = D(r1, s0_0_2, 0x38FBEC0A, 0x0CF5FDF4, 0x500201F2, 0xEFF0F6E7);
	r2 = D(r2, s0_0_2, 0xD5F70204, 0xF80BFB0A, 0x0DEAEEF3, 0xFC060C0E);
	r0 = D(r0, s0_1_0, 0xEF2E2603, 0x8F813D0F, 0x07ED1101, 0x32FA0AFF);
	r1 = D(r1, s0_1_0, 0x0004F80B, 0xF637DD01, 0xF3D6F906, 0x193018EE);
	r2 = D(r2, s0_1_0, 0xF81914F9, 0x05140709, 0xE71E060E, 0x028107FD);
	r0 = D(r0, s0_1_1, 0xF012CB10, 0x301292F8, 0xF4E0410C, 0x092A48F0);
	r1 = D(r1, s0_1_1, 0x280ACF22, 0xE106CC37, 0x139BF029, 0x0B1A4DFA);
	r2 = D(r2, s0_1_1, 0x2DB08144, 0xF10ED721, 0x1EE82825, 0x28D82FE0);
	r0 = D(r0, s0_1_2, 0xF102D381, 0x0AFD184A, 0xF0FCE981, 0x1C0AFAF8);
	r1 = D(r1, s0_1_2, 0xEFC9E429, 0xEAFB0A5B, 0xE1BF286A, 0x2803D321);
	r2 = D(r2, s0_1_2, 0xFA15F87F, 0xF4F825D6, 0x10EE0010, 0xFF01FEAB);
	r0 = D(r0, s0_2_0, 0xFC1FF4F7, 0x0E042B06, 0x02FD0014, 0x00FB060C);
	r1 = D(r1, s0_2_0, 0xE51CDE03, 0x06CCD1F6, 0xF620FD04, 0xFA0CF200);
	r2 = D(r2, s0_2_0, 0xF5EB2502, 0x0206F5F7, 0xEF2635FF, 0x28810B05);
	r0 = D(r0, s0_2_1, 0x130DDE27, 0x16ED811C, 0x04160008, 0x02FB180A);
	r1 = D(r1, s0_2_1, 0x08FC1BF9, 0xFE06E9F6, 0x00021F08, 0x04FA2A05);
	r2 = D(r2, s0_2_1, 0x04D41A21, 0x191088D0, 0xF30D9FEB, 0x11E4D7CE);
	r0 = D(r0, s0_2_2, 0xF30F0535, 0x06F64DE2, 0x0309012A, 0x03F62111);
	r1 = D(r1, s0_2_2, 0xF90DF126, 0x08F91B1F, 0xFD12C713, 0x03EDF515);
	r2 = D(r2, s0_2_2, 0x08E3F82B, 0x0A2242FB, 0xFB0ADA07, 0x01FE25D6);
	r0 = D(r0, s1_0_0, 0xFD0002EC, 0xE8F305E2, 0x14FB041D, 0x16F90318);
	r1 = D(r1, s1_0_0, 0xDAE6EA0C, 0xE3F0E31B, 0xEE10FA06, 0x12FB0A1E);
	r2 = D(r2, s1_0_0, 0xFAD507D0, 0x1F10F9D6, 0x07FCF905, 0x00EC1A05);
	r0 = D(r0, s1_0_1, 0xE720F2F9, 0x07EFCACD, 0x15EDFAE1, 0x21090419);
	r1 = D(r1, s1_0_1, 0xDD0F0BE9, 0xD6D4F91D, 0x0E15F82F, 0xFE32F6E8);
	r2 = D(r2, s1_0_1, 0xFC07EEF3, 0xFC01401F, 0x00F10122, 0x250507F1);
	r0 = D(r0, s1_0_2, 0xE1F20E10, 0x0FFBF812, 0x1EFC0501, 0x00FBF512);
	r1 = D(r1, s1_0_2, 0xDD112CF8, 0xFE11EEFD, 0x1A0BF4EF, 0x06180200);
	r2 = D(r2, s1_0_2, 0x280DFEEF, 0x151CFFF6, 0x03160A00, 0x0FE6FFF7);
	r0 = D(r0, s1_1_0, 0xE9FD0232, 0xE802142D, 0xE9FAFA09, 0xE106F3FF);
	r1 = D(r1, s1_1_0, 0xFD01D711, 0x04DB03D0, 0xFBEBF2F2, 0x0409D8F4);
	r2 = D(r2, s1_1_0, 0x28EB219D, 0xFF2C383A, 0x13F116F3, 0xFA01F2CB);
	r0 = D(r0, s1_1_1, 0x2B453611, 0x24222581, 0x0A2723F5, 0x11FE1FF6);
	r1 = D(r1, s1_1_1, 0xEAC2EAD7, 0xEE0B0F31, 0xD5DCEE20, 0xF2C3F820);
	r2 = D(r2, s1_1_1, 0xFE7FF1EA, 0x05403911, 0x0F35F009, 0x2B1DE824);
	r0 = D(r0, s1_1_2, 0x1905F413, 0x0701EFF4, 0x110BFF0E, 0xDAE7E9FC);
	r1 = D(r1, s1_1_2, 0x1A5629F5, 0xE5120DF8, 0x1E1A2A01, 0x000EEAFC);
	r2 = D(r2, s1_1_2, 0xD11C2203, 0x0BCCE518, 0x0411010A, 0xEC150508);
	r0 = D(r0, s1_2_0, 0xDCDF0803, 0xE915E6FC, 0x1AFBFF00, 0x01010402);
	r1 = D(r1, s1_2_0, 0x241502CC, 0x2E1D1CF3, 0xEAFC0100, 0xFC130CED);
	r2 = D(r2, s1_2_0, 0x1CFEFE08, 0xEAFDF4F3, 0x03EF0D04, 0xE3E90A08);
	r0 = D(r0, s1_2_1, 0x16E1D81C, 0x072C01DD, 0x1AF8F503, 0x05EBDF05);
	r1 = D(r1, s1_2_1, 0x2EF8CBF1, 0x2E323AEF, 0xFF09FD03, 0xFBE9FB01);
	r2 = D(r2, s1_2_1, 0xE00FF222, 0xF4DBBC1F, 0xE9001B03, 0x04DFFF0F);
	r0 = D(r0, s1_2_2, 0x1D17DBF2, 0x0005FF14, 0x13F7F3FE, 0xFC020904);
	r1 = D(r1, s1_2_2, 0x18DF18FA, 0x0E1ADF10, 0x10071D02, 0xF8FC18FC);
	r2 = D(r2, s1_2_2, 0xDA21FAFF, 0xE5D1A904, 0xFAF3FAFB, 0xD806E50C);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFFE60519, 0x10D10F02, 0x0808FFFC, 0x020815F7);
	r1 = D(r1, s0_0_0, 0x124521DE, 0x0319F500, 0x070DF0F7, 0x011106E1);
	r2 = D(r2, s0_0_0, 0xFFFB26F9, 0xF3E01A34, 0xFFFBED03, 0x0BECF7F8);
	r0 = D(r0, s0_0_1, 0xD8819B03, 0xE2900A2E, 0xEFFFD51F, 0x1702E626);
	r1 = D(r1, s0_0_1, 0x092637E1, 0xD72A21EA, 0xF8F62EFC, 0xDB5202F4);
	r2 = D(r2, s0_0_1, 0x2C3808D8, 0xCAAD81F4, 0x071B0D11, 0x62171715);
	r0 = D(r0, s0_0_2, 0xEC8BE711, 0x0C9A12ED, 0xF7EAF2F1, 0x0A191733);
	r1 = D(r1, s0_0_2, 0xFEEAF4D0, 0x1B03F7F6, 0x04F6FAE2, 0xEB26DB2E);
	r2 = D(r2, s0_0_2, 0xF6080AD6, 0xFED4F1F3, 0x06F7F002, 0xFEFA0B0F);
	r0 = D(r0, s0_1_0, 0x0EEDFFFA, 0x1A0DECED, 0x110100FF, 0x10FA120B);
	r1 = D(r1, s0_1_0, 0x15F40B20, 0xF8EC0A3E, 0xFEFEEE0F, 0x1B11FCF2);
	r2 = D(r2, s0_1_0, 0xEFF2CE0A, 0xEEE5EBFA, 0xFAE20215, 0xC6EBDE2C);
	r0 = D(r0, s0_1_1, 0xD822A01D, 0xA245AE1A, 0x114D1CE2, 0x1F170CDD);
	r1 = D(r1, s0_1_1, 0x2B4DEFFE, 0x088CF75B, 0x1CD2421E, 0x0BE91D05);
	r2 = D(r2, s0_1_1, 0x18D67329, 0x811981BD, 0x03EFF534, 0xB1C8451D);
	r0 = D(r0, s0_1_2, 0xD2B12E16, 0xEB9FD10C, 0xF5F7FC08, 0x1CF23400);
	r1 = D(r1, s0_1_2, 0x95E0CB04, 0x1A0425F6, 0x8138CCE2, 0xEF0A1503);
	r2 = D(r2, s0_1_2, 0xC1EF301E, 0x11F22B1B, 0x07E6C111, 0xB11535D0);
	r0 = D(r0, s0_2_0, 0x06042613, 0x0C0BEE12, 0x09021811, 0x05000A04);
	r1 = D(r1, s0_2_0, 0xE720F2F5, 0xD20BEEED, 0x07FEF706, 0x04030B08);
	r2 = D(r2, s0_2_0, 0x01FFF4FA, 0x0809F8FA, 0xF5FEDBF0, 0xCDF5081E);
	r0 = D(r0, s0_2_1, 0x2D0EDCD7, 0x08F75112, 0x060A17F4, 0xFA070100);
	r1 = D(r1, s0_2_1, 0xF3DF0A47, 0xB9FDB1F6, 0x00FF0002, 0xDA03E802);
	r2 = D(r2, s0_2_1, 0xF9F51309, 0x0FFB12E7, 0xF41D22FA, 0xCB1A1808);
	r0 = D(r0, s0_2_2, 0x560C5F1C, 0xEBF2EA0C, 0x0C0901FA, 0x13031902);
	r1 = D(r1, s0_2_2, 0xF12415F2, 0x0BFD03F4, 0xD1FEF2F4, 0x05FD0C09);
	r2 = D(r2, s0_2_2, 0xCDFE1006, 0x59092809, 0xC9E5C710, 0xB4011ADA);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.151e-02, 4.747e-02, -1.342e-01, 1.201e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(4.041e-03, 2.988e-02, 3.235e-02, 4.939e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(4.670e-03, -1.273e-02, 1.376e-03, 7.638e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BILINEAR-MPV-NVL-conv2
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv1_pt)
#define l1(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv1_pt)
#define l2(x, y) conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv1_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[3][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(3, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2;
	vec4 f0, f1, f2;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFD03FDF4, 0x1E080CE7, 0x0308FB00, 0xF4F910F3);
	r1 = D(r1, s0_0_0, 0x04200CEE, 0xEE17EE08, 0x01050500, 0xEE04FA01);
	r2 = D(r2, s0_0_0, 0x02020605, 0xF8030AF3, 0xF0000818, 0x060103F3);
	r0 = D(r0, s0_0_1, 0x2510F3E5, 0xF1EA2F04, 0xFA150309, 0x1A07E0F5);
	r1 = D(r1, s0_0_1, 0x0311E809, 0x08FBF12C, 0xFF160BF6, 0xEAF60910);
	r2 = D(r2, s0_0_1, 0x12F61DFC, 0x2E05E3DE, 0x0300FA41, 0xF50AFB1F);
	r0 = D(r0, s0_0_2, 0xFCFD02FA, 0x1C050014, 0x030903FF, 0xF30DFA10);
	r1 = D(r1, s0_0_2, 0x2001EFED, 0x0AFD0007, 0x040BFFFC, 0x0005F3F6);
	r2 = D(r2, s0_0_2, 0xFAFD0F0C, 0x0F04F7F5, 0xFC09FD25, 0xFC08020E);
	r0 = D(r0, s0_1_0, 0x42FDFBF9, 0x1CE020E9, 0xFD0BFCF9, 0x41F1EEDD);
	r1 = D(r1, s0_1_0, 0x1103110A, 0x2608F80A, 0xD0220AFF, 0xE40907F5);
	r2 = D(r2, s0_1_0, 0xD701F606, 0x05F226F6, 0xC3001400, 0x021106F7);
	r0 = D(r0, s0_1_1, 0xF4FE00EE, 0xB1250F81, 0x231E13F6, 0xF70F9B00);
	r1 = D(r1, s0_1_1, 0x23D55C1D, 0x88EFD537, 0x423BFFFA, 0x4E13EEF8);
	r2 = D(r2, s0_1_1, 0x4E17D8D6, 0x421EFF16, 0xD0E91DE3, 0xD1F90216);
	r0 = D(r0, s0_1_2, 0x1105FEEE, 0xF6EC43F8, 0x02FEFEF8, 0xFEF5DD0C);
	r1 = D(r1, s0_1_2, 0x1011FEF7, 0x3411F2FA, 0x031F0601, 0x03FE0CF1);
	r2 = D(r2, s0_1_2, 0x0DFC1BF5, 0xFAEF0514, 0xF70808F8, 0xFF001307);
	r0 = D(r0, s0_2_0, 0x07FDFF0B, 0x231D1016, 0xF30AFFF7, 0x160BE1F0);
	r1 = D(r1, s0_2_0, 0xE9F8FC08, 0xF6F3010C, 0xEE050207, 0x21FB0500);
	r2 = D(r2, s0_2_0, 0xED00FF03, 0xE9001E1A, 0x0DFE0708, 0x17F1F50D);
	r0 = D(r0, s0_2_1, 0xFD05F8F5, 0x15F22B0F, 0xFD03F5FA, 0x07ECCCE2);
	r1 = D(r1, s0_2_1, 0xBB091D05, 0x33F6FC04, 0xFC200507, 0x06FD0404);
	r2 = D(r2, s0_2_1, 0xE70CD90B, 0xCDEA150B, 0x1310FD01, 0x04EE0613);
	r0 = D(r0, s0_2_2, 0x05030B04, 0x011112F2, 0x020AFD05, 0xFD02F2FC);
	r1 = D(r1, s0_2_2, 0x3CE70C0F, 0x0B05FE04, 0x040101FE, 0x07000BF4);
	r2 = D(r2, s0_2_2, 0x16F30C0A, 0xF10A110A, 0xEEF40B19, 0x16FEFEF4);
	r0 = D(r0, s1_0_0, 0xFDF804FE, 0x1C2617E1, 0xFA0213FF, 0x1007E9CF);
	r1 = D(r1, s1_0_0, 0x0E1FFD28, 0xEF16CFE2, 0x00FFFF03, 0xFCEF0E19);
	r2 = D(r2, s1_0_0, 0x00040800, 0x060DFAFE, 0xFCF0E8EB, 0xF804FA13);
	r0 = D(r0, s1_0_1, 0xF7F60BE4, 0xEEE8CB9B, 0xFCF20FF5, 0xF5FB1AB9);
	r1 = D(r1, s1_0_1, 0xF31BEC05, 0xD40EE606, 0xF7FEED08, 0x1BF01F34);
	r2 = D(r2, s1_0_1, 0xF7F0F904, 0xF812D702, 0xEFF1C1D2, 0x021C1C0C);
	r0 = D(r0, s1_0_2, 0xF70306F4, 0xF828D805, 0x01FB0BFA, 0xF708DCB8);
	r1 = D(r1, s1_0_2, 0x07010907, 0x0D0DF1F9, 0x0105F8FE, 0xFAF41001);
	r2 = D(r2, s1_0_2, 0x0406E5FD, 0xFD0A1709, 0x0410C9D7, 0xFC030500);
	r0 = D(r0, s1_1_0, 0xF9FF0DFD, 0xF5CCD325, 0x01F1FB0C, 0xEEDFD3CF);
	r1 = D(r1, s1_1_0, 0xECC3030E, 0xFDA20DF3, 0xFAF4F804, 0x061FF509);
	r2 = D(r2, s1_1_0, 0x042E1BEC, 0xFA1FF9F7, 0x1D060204, 0x1122FEF3);
	r0 = D(r0, s1_1_1, 0x4223FEEC, 0xA2831EAF, 0xE9F4EDF9, 0xEB1A1FCE);
	r1 = D(r1, s1_1_1, 0xB39E3CED, 0x32F0031C, 0xF6040907, 0xD1051806);
	r2 = D(r2, s1_1_1, 0x2930D31D, 0xF20D05DF, 0x2627E2F7, 0xDBF33C09);
	r0 = D(r0, s1_1_2, 0x04FE00FB, 0xC1F0058F, 0x17FFFF07, 0xE708D9C0);
	r1 = D(r1, s1_1_2, 0x22211B39, 0x0810F8FF, 0xF4FC0602, 0x0F03FA14);
	r2 = D(r2, s1_1_2, 0x07FBF1F9, 0xF8001602, 0x0800DEF6, 0x01FAEFF3);
	r0 = D(r0, s1_2_0, 0xFAF40501, 0x0216F519, 0x01FB04FE, 0x172213D6);
	r1 = D(r1, s1_2_0, 0x05E7E620, 0xF6EF010F, 0xFCF8FF03, 0xFD060E01);
	r2 = D(r2, s1_2_0, 0xF1061CFC, 0x05FD0103, 0xF70E06F8, 0xF8F3FA07);
	r0 = D(r0, s1_2_1, 0xFDE800F9, 0xD1FC1E20, 0x10F70306, 0x12F613C1);
	r1 = D(r1, s1_2_1, 0xBCB70C39, 0xEEF7FA08, 0x06FAFEFC, 0x0AFCFC00);
	r2 = D(r2, s1_2_1, 0x1309EAF2, 0xFCE9FB03, 0x191A06F3, 0xF5F9F709);
	r0 = D(r0, s1_2_2, 0xF70104F9, 0x061809E1, 0x04FEFFF6, 0xE1F70ED5);
	r1 = D(r1, s1_2_2, 0xCDD8091C, 0xFB02FCFC, 0xF5FF0600, 0xFF00040A);
	r2 = D(r2, s1_2_2, 0x090A0707, 0xFDFE01FD, 0xF8FB03F8, 0x0A0600F8);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFA02080B, 0xE608EAF6, 0x09F8F7FD, 0xDC1632F0);
	r1 = D(r1, s0_0_0, 0xFEE3DDE4, 0x10FBE120, 0xF8FA01FD, 0x0D0306FA);
	r2 = D(r2, s0_0_0, 0xFC0DDAF4, 0xEF1207EE, 0x02F9FD10, 0xFCEC0810);
	r0 = D(r0, s0_0_1, 0xF5E81A0C, 0xE40CF943, 0x10FE0101, 0xF5F33F1A);
	r1 = D(r1, s0_0_1, 0x0A06EA05, 0x2622D53A, 0xF40303FA, 0xF912D7DC);
	r2 = D(r2, s0_0_1, 0xF302C9DE, 0xD0CB22E5, 0x09FC1635, 0x171BD405);
	r0 = D(r0, s0_0_2, 0xF9FD060D, 0x1AE3F9E2, 0x01F9F4FB, 0xF7EB1213);
	r1 = D(r1, s0_0_2, 0xF3E7EDFB, 0x0ED9DF0A, 0x0FF70400, 0xEDFB0007);
	r2 = D(r2, s0_0_2, 0x22F1F7F2, 0xE6030F04, 0x1CF30AF9, 0x20F8EB07);
	r0 = D(r0, s0_1_0, 0xF8000304, 0xF301F41C, 0xFEFDEFFE, 0x10F948ED);
	r1 = D(r1, s0_1_0, 0x12E9C7EC, 0x0503D015, 0xF5F80BF8, 0xF4F80BEA);
	r2 = D(r2, s0_1_0, 0x0A0BEEF5, 0x15F937EF, 0x0B1518F5, 0xFF04C90A);
	r0 = D(r0, s0_1_1, 0x1BE3E501, 0xC1417D0E, 0x181305F9, 0xFBE8D927);
	r1 = D(r1, s0_1_1, 0xFE5C0C3A, 0x2B1EED3F, 0xF90515E0, 0xEDECD9F0);
	r2 = D(r2, s0_1_1, 0xE1DFCFC2, 0xF74618CB, 0xE4D206FA, 0x29340F0A);
	r0 = D(r0, s0_1_2, 0xFA050FFB, 0x480918D7, 0xF50EFBF7, 0xDC08F00E);
	r1 = D(r1, s0_1_2, 0xF1DE05D6, 0xEBEEFEFE, 0x0901FFF5, 0x13E4FAF9);
	r2 = D(r2, s0_1_2, 0xFAE9EEEF, 0x03F01B10, 0x18F913F4, 0x1716F6F5);
	r0 = D(r0, s0_2_0, 0xFCF7F90A, 0xFAE0F7FC, 0x0BFDF9FF, 0xE41D0D08);
	r1 = D(r1, s0_2_0, 0xF1EDE603, 0x0BF0E615, 0x02FC04FF, 0x0200F902);
	r2 = D(r2, s0_2_0, 0xFD06050C, 0xFD04FE06, 0xF1F9100B, 0x08F8DD06);
	r0 = D(r0, s0_2_1, 0x0B010500, 0xF1D409D6, 0x06FBFD00, 0x1A1B2A14);
	r1 = D(r1, s0_2_1, 0xEFFE0506, 0xF7FFFCF0, 0x020A00FE, 0xFEE30E03);
	r2 = D(r2, s0_2_1, 0x1CE20B1D, 0x00FF1B10, 0xFE060908, 0xEBF3FB06);
	r0 = D(r0, s0_2_2, 0x0302FA0A, 0xCDD80742, 0x0004FFFE, 0x3838151D);
	r1 = D(r1, s0_2_2, 0x0EDD09DC, 0x09E304F5, 0xFDF4FF09, 0x01FBFE06);
	r2 = D(r2, s0_2_2, 0xE60C0201, 0xF7FCFC17, 0xF8160901, 0xDFE1010B);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(2.331e-02, 8.120e-02, 7.923e-02, 3.157e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(2.887e-02, 6.344e-02, -7.450e-01, -1.069e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.790e-02, 6.261e-03, 7.300e-02, 1.752e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BILINEAR-MPV-NVL-conv3
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND conv2
//!BIND LUMA
//!SAVE conv3
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv2_pt)
#define l1(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv2_pt)
#define l2(x, y) conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv2_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[3][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(3, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2;
	vec4 f0, f1, f2;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xF9EF000D, 0xF705A211, 0x040301FD, 0xF6FBF716);
	r1 = D(r1, s0_0_0, 0xFA09FAFE, 0x03FCFFF9, 0x0204FEFF, 0x03E4F20F);
	r2 = D(r2, s0_0_0, 0xD0818181, 0xFBF6F200, 0x0B24F8F4, 0x070712EB);
	r0 = D(r0, s0_0_1, 0xE7FD07FC, 0x02FFC3FB, 0x03FF1600, 0xEAC7ED16);
	r1 = D(r1, s0_0_1, 0x0C3C07DF, 0x0813EFF6, 0x0405FDFF, 0xD81B0204);
	r2 = D(r2, s0_0_1, 0x2C0FF5E1, 0xFBD9FD16, 0xDCF2E5FA, 0xED0F0902);
	r0 = D(r0, s0_0_2, 0xE5120406, 0x0802D1F9, 0xF00E2001, 0xC80D061F);
	r1 = D(r1, s0_0_2, 0xF0CDBF07, 0x1606F501, 0x0500FC02, 0x0CFEFD03);
	r2 = D(r2, s0_0_2, 0xEC0AFA00, 0xF8FFF2FE, 0x060C0002, 0x09F4FD05);
	r0 = D(r0, s0_1_0, 0xFA02EF13, 0x02F4B413, 0xF8000A04, 0x0400ED10);
	r1 = D(r1, s0_1_0, 0x0801F911, 0x0502EA04, 0x030CFD04, 0xFBDBED14);
	r2 = D(r2, s0_1_0, 0x0E1AFEF4, 0xF9CAF707, 0xDF0504D8, 0x0BFDF9F8);
	r0 = D(r0, s0_1_1, 0xF904F705, 0xEB0E18FD, 0xFCF60BE9, 0xFE0EFCEF);
	r1 = D(r1, s0_1_1, 0xE017D9C0, 0x0FDAF031, 0x053804D1, 0x081E18C1);
	r2 = D(r2, s0_1_1, 0xE8010F31, 0xFDA5FD7F, 0xCDF3DE08, 0x0A03F546);
	r0 = D(r0, s0_1_2, 0x0BFFF3E4, 0x09FBCC03, 0xFCE42C17, 0x252A1AEF);
	r1 = D(r1, s0_1_2, 0xFDE6AE20, 0x0B0300F0, 0x020703FB, 0x092506FE);
	r2 = D(r2, s0_1_2, 0xFA15070B, 0x02C4F40E, 0x09EFDE04, 0xFBFCF419);
	r0 = D(r0, s0_2_0, 0xF7FEE30E, 0xF7F3C0FC, 0x00FD0A02, 0xFEFF070B);
	r1 = D(r1, s0_2_0, 0x04F50007, 0x0906F104, 0x0000FEFE, 0xF4EBF0F2);
	r2 = D(r2, s0_2_0, 0xFFF3F70D, 0x040EDE08, 0xEB02E601, 0x010CEB0A);
	r0 = D(r0, s0_2_1, 0xE607F020, 0xFA09C119, 0x031208FF, 0xFEFB02F3);
	r1 = D(r1, s0_2_1, 0xFA14E6FC, 0x160605E2, 0xFF1506F9, 0x00F8FCFD);
	r2 = D(r2, s0_2_1, 0x0000FBF3, 0xFDCFEB2D, 0xF6F3E1EF, 0xF9E8F40D);
	r0 = D(r0, s0_2_2, 0xEEF8FA1A, 0xFBF8D7EB, 0x0F050FE0, 0xFBFD02F7);
	r1 = D(r1, s0_2_2, 0x02EBAB03, 0x0CFD0DF8, 0xFD060203, 0x020AFFFE);
	r2 = D(r2, s0_2_2, 0x0309FE01, 0x01C8F404, 0xEB02D9FB, 0x0CFF09F9);
	r0 = D(r0, s1_0_0, 0x0A23F804, 0x0E79FEC7, 0xFAEB0DF9, 0x04DCEE18);
	r1 = D(r1, s1_0_0, 0xF11A0311, 0xFD2CFBF8, 0xF90EFF05, 0xF709EEE3);
	r2 = D(r2, s1_0_0, 0x81818181, 0x0548F9FC, 0xFD1FF9F9, 0xFA13FD04);
	r0 = D(r0, s1_0_1, 0x0B700603, 0xE63D09F5, 0x0EDC0B15, 0x1665D71C);
	r1 = D(r1, s1_0_1, 0xF67FD9F1, 0x010105EA, 0xF70EFE00, 0x0444F101);
	r2 = D(r2, s1_0_1, 0x024AF5E8, 0xFEF9F9EC, 0xEDDBFAF1, 0x087FFAF4);
	r0 = D(r0, s1_0_2, 0xF7E8FB0A, 0x007F11EA, 0x0AD2F5FD, 0x0240F4FF);
	r1 = D(r1, s1_0_2, 0xE49BFEFC, 0xF70EF7F7, 0xFE15FE02, 0xF3FEF707);
	r2 = D(r2, s1_0_2, 0xF905FA02, 0xFE4F07F5, 0x02510205, 0xF7FBF1F6);
	r0 = D(r0, s1_1_0, 0xFAD8F413, 0x0A70FCCD, 0xFB1A06F7, 0xF52D01FC);
	r1 = D(r1, s1_1_0, 0x0FE10900, 0xECFD02E7, 0x072AFF01, 0xE417DFCC);
	r2 = D(r2, s1_1_0, 0x0208070C, 0xFD22FD04, 0x1F7FF70F, 0xF44AF6F7);
	r0 = D(r0, s1_1_1, 0xD992E4F1, 0x3EC981E2, 0xEECE1D03, 0xBF7F05FC);
	r1 = D(r1, s1_1_1, 0xFB7F0606, 0x2081DF10, 0x0C7FFC08, 0x3C7FF1FF);
	r2 = D(r2, s1_1_1, 0x0719E204, 0x12810B24, 0x1581C8F5, 0xD28BDEE3);
	r0 = D(r0, s1_1_2, 0x0D70F702, 0xF57F08DF, 0xE19B1C12, 0x2B67F708);
	r1 = D(r1, s1_1_2, 0xF881E4E7, 0x1E66F6F4, 0xF911FF02, 0xE9090106);
	r2 = D(r2, s1_1_2, 0x01FA0608, 0x0E3CFB03, 0xF01927F6, 0xF5F714F2);
	r0 = D(r0, s1_2_0, 0xFA22FE0C, 0x0D4509F3, 0x091609F5, 0x0DCCF7F8);
	r1 = D(r1, s1_2_0, 0x0726030B, 0x081900FC, 0xFE28FD01, 0x15EFFFFA);
	r2 = D(r2, s1_2_0, 0x0239FFFC, 0xF332FCFB, 0x16070F01, 0xF925FD01);
	r0 = D(r0, s1_2_1, 0x29D70B16, 0x0DF30AF0, 0xFB0F13FE, 0x07E401F8);
	r1 = D(r1, s1_2_1, 0xED00F2FF, 0xE047FDFE, 0xF838FC03, 0x0608FC01);
	r2 = D(r2, s1_2_1, 0xE8220705, 0x242AF8F6, 0x0C7FEC0F, 0x1236FD06);
	r0 = D(r0, s1_2_2, 0x0FE40004, 0x097F1BDD, 0x00CAFBF6, 0xFCF10103);
	r1 = D(r1, s1_2_2, 0x1FB6F9FE, 0xF4EFF309, 0xFB1BFF00, 0xF8F1FC05);
	r2 = D(r2, s1_2_2, 0x020FFD01, 0x0D26FDFE, 0xECDA0F0B, 0xF319FA02);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x08FBF9FF, 0x05FE05F6, 0x03020103, 0x00F502F2);
	r1 = D(r1, s0_0_0, 0x0408FCF3, 0xFA01FEF4, 0x02FDFF00, 0x0FFE0A0C);
	r2 = D(r2, s0_0_0, 0xE0813A26, 0xF8EF08FA, 0xF3F4090B, 0xF505FBFB);
	r0 = D(r0, s0_0_1, 0xDF0CF8FC, 0x11EFFDFB, 0x03EC0EEC, 0xF90AEB29);
	r1 = D(r1, s0_0_1, 0xFB03050D, 0x1402FD01, 0x0400FD00, 0xEFFD09FC);
	r2 = D(r2, s0_0_1, 0x0BFC1123, 0x14FCFD06, 0x12E50B23, 0x0809F7EF);
	r0 = D(r0, s0_0_2, 0xF6FDF704, 0x01FA0919, 0xF01F07F6, 0xF000F2EB);
	r1 = D(r1, s0_0_2, 0x02F01520, 0x05F20A04, 0xFFFCFE04, 0xF801F401);
	r2 = D(r2, s0_0_2, 0x070BF7F1, 0xFBFE0DF5, 0xFB05F0EE, 0x0FFF0103);
	r0 = D(r0, s0_1_0, 0x0804FF04, 0x1606FDFB, 0xF2FEFF02, 0x04071A07);
	r1 = D(r1, s0_1_0, 0x110A0EFA, 0x100900F5, 0x02FD0C04, 0x06F8EA19);
	r2 = D(r2, s0_1_0, 0x25F110FF, 0x02FDF90A, 0xC9ED1D04, 0x02FCF611);
	r0 = D(r0, s0_1_1, 0x0110F052, 0xCDA0242F, 0xD3DC17F5, 0x0AF11C1F);
	r1 = D(r1, s0_1_1, 0xFEE12B1B, 0x08E3EEF7, 0xFC041D0E, 0x151E26DF);
	r2 = D(r2, s0_1_1, 0xF60EF201, 0x2012E722, 0x1CEE10F0, 0x06161BFE);
	r0 = D(r0, s0_1_2, 0x291A02F0, 0x03F50B1F, 0x0136F9D2, 0xFAE6F200);
	r1 = D(r1, s0_1_2, 0xF0F1F314, 0x14051FE0, 0xFF010303, 0xFFFEE808);
	r2 = D(r2, s0_1_2, 0x0401F6FA, 0x05FA0603, 0xF9F9081D, 0xF6EBFC07);
	r0 = D(r0, s0_2_0, 0xFB0A0AFD, 0xFC0CF0FC, 0x00FFFC07, 0x060C0BFB);
	r1 = D(r1, s0_2_0, 0x0413FFF3, 0x010E04FB, 0x02020201, 0x0A15EEFC);
	r2 = D(r2, s0_2_0, 0x00001501, 0x0CF70A07, 0xEBE9EA00, 0x07090202);
	r0 = D(r0, s0_2_1, 0xF61BF2FB, 0xCC10E8F4, 0xF6EE0E0D, 0x040BFAFA);
	r1 = D(r1, s0_2_1, 0x1E01F4FD, 0x14EF2310, 0xFEFB0100, 0x0DEF0D01);
	r2 = D(r2, s0_2_1, 0xFAF619FC, 0x17FE0C20, 0x12E92C12, 0xEA0A08F1);
	r0 = D(r0, s0_2_2, 0xE2FEE9FB, 0xE20520F5, 0x1DEBFF08, 0x0103F8F5);
	r1 = D(r1, s0_2_2, 0xEE0D06E5, 0x09F6EFF8, 0xFAFDFD06, 0xFB04FCFF);
	r2 = D(r2, s0_2_2, 0x02FFFF00, 0x02EC0BFE, 0xD705F838, 0x050503FC);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.128e-02, 7.643e-02, 2.833e-02, 5.096e-04);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.213e-02, -2.235e-02, 5.260e-04, -7.471e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-7.552e-03, -6.577e-02, 6.999e-02, -1.674e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BILINEAR-MPV-NVL-conv4
//!HOOK LUMA
//!COMPUTE 24 8 8 8
//!BIND conv3
//!BIND LUMA
//!SAVE conv4
//!WIDTH LUMA.w 3 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
#define l0(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv3_pt)
#define l1(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv3_pt)
#define l2(x, y) conv3_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv3_pt)
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[3][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(3, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			vec4 v0 = l0(x - 1, y - 1) * 1.0000000e+00;
			vec4 v1 = l1(x - 1, y - 1) * 1.0000000e+00;
			vec4 v2 = l2(x - 1, y - 1) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2;
	vec4 f0, f1, f2;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xF4030D31, 0x02FC0302, 0x0100FD07, 0xF8F50300);
	r1 = D(r1, s0_0_0, 0xFBFCFF10, 0xFDFE010E, 0x0407FDF7, 0xFCFB0005);
	r2 = D(r2, s0_0_0, 0xFFFE0003, 0xFE0201F9, 0xFFF8F9EF, 0x0A060415);
	r0 = D(r0, s0_0_1, 0xFE011910, 0x07FF06FC, 0xF2FD1835, 0xFBFC2E23);
	r1 = D(r1, s0_0_1, 0x01F305EB, 0xFDFF0C12, 0x0C010A08, 0x03FD01FE);
	r2 = D(r2, s0_0_1, 0x010300FA, 0xF9FB02FE, 0xF8FC01F9, 0x00030205);
	r0 = D(r0, s0_0_2, 0xFF00FFFF, 0xFD00F902, 0xFF010CFE, 0xFC05150D);
	r1 = D(r1, s0_0_2, 0xFB03F3F0, 0x00FE0401, 0xFA0001FD, 0x000100F9);
	r2 = D(r2, s0_0_2, 0xFDFF0002, 0x01FCFBFF, 0x070002FA, 0x02000002);
	r0 = D(r0, s0_1_0, 0x9CEB1BC1, 0x06E201EC, 0xEDF202FA, 0x080101FD);
	r1 = D(r1, s0_1_0, 0x06CF12EC, 0xF7F807F4, 0xF9DC04DD, 0xFD16000A);
	r2 = D(r2, s0_1_0, 0xEBF01909, 0xFCCA06F8, 0xF2E000FD, 0xE5DF0EE6);
	r0 = D(r0, s0_1_1, 0xFDFD3603, 0xF5FA1527, 0xB5F13ABF, 0xC0F01CDB);
	r1 = D(r1, s0_1_1, 0x03EE2622, 0xF500F7FB, 0xFCF21EFE, 0x0101181B);
	r2 = D(r2, s0_1_1, 0x02FD3230, 0xFAFD2215, 0xF9F722FE, 0x0CF02B02);
	r0 = D(r0, s0_1_2, 0xF8FF0304, 0x01FD03EE, 0xFB011516, 0x08FF0909);
	r1 = D(r1, s0_1_2, 0xF5FE1027, 0x02FF080B, 0xFDFE08EF, 0xFDFB05FD);
	r2 = D(r2, s0_1_2, 0x000203FA, 0xFEFD0503, 0x05050607, 0x05051005);
	r0 = D(r0, s0_2_0, 0x07FAFE00, 0x05F9FEFD, 0x07FE0005, 0x04FDFF01);
	r1 = D(r1, s0_2_0, 0x1001030F, 0x03FEFF01, 0x07F608FF, 0x04FB02FD);
	r2 = D(r2, s0_2_0, 0xD5F40BEB, 0x0AFB04FC, 0xF0F90105, 0x15F201FB);
	r0 = D(r0, s0_2_1, 0x0D020007, 0xFAF701F6, 0xFCFC02FE, 0x00FF00FE);
	r1 = D(r1, s0_2_1, 0xE60006F2, 0xF90101F8, 0x16FE0509, 0x1B00FD06);
	r2 = D(r2, s0_2_1, 0xFDFF17FA, 0x07F30300, 0xE10206EB, 0x20F6FE0E);
	r0 = D(r0, s0_2_2, 0x00FFFEFF, 0xF7FC0009, 0x0C00FE02, 0x04FEFF02);
	r1 = D(r1, s0_2_2, 0x0A0209F7, 0x04000103, 0xFC00F7F7, 0xFF00FF01);
	r2 = D(r2, s0_2_2, 0xFCFDFDFE, 0x07FA01F7, 0x0B02FD08, 0x09F9FFFB);
	r0 = D(r0, s1_0_0, 0xF50BF106, 0x05F5F607, 0xFA090A01, 0xF90C0600);
	r1 = D(r1, s1_0_0, 0x002001FC, 0xFE100105, 0x05FE0C13, 0x000A0508);
	r2 = D(r2, s1_0_0, 0x00040903, 0xFB12F4FD, 0xFD14FE01, 0xF9FE04F8);
	r0 = D(r0, s1_0_1, 0x06FE03F7, 0x01060807, 0xF905D000, 0xF7B8D900);
	r1 = D(r1, s1_0_1, 0x100A2514, 0xFFF5FD02, 0xDEF9F6FD, 0x12EE10FF);
	r2 = D(r2, s1_0_1, 0x0701FEFA, 0x0416FD04, 0x1309F7FE, 0xE0FDDFF9);
	r0 = D(r0, s1_0_2, 0xFEF9FC04, 0x0605EEFE, 0x13F510FE, 0x1EEB11FD);
	r1 = D(r1, s1_0_2, 0xE707F607, 0x18010CFE, 0x150811F9, 0x0C00FFFF);
	r2 = D(r2, s1_0_2, 0x0004FB02, 0x0B0DFBFF, 0x0FF90FFD, 0x0CF7F7FC);
	r0 = D(r0, s1_1_0, 0x0111FF0E, 0x0CCEBD07, 0xFB09FA14, 0xFF08FF07);
	r1 = D(r1, s1_1_0, 0x00E2A6E8, 0x020EFF15, 0x06BCEE1C, 0x03271A15);
	r2 = D(r2, s1_1_0, 0xFB01CB10, 0x0313FEFC, 0xF9330113, 0xF8220805);
	r0 = D(r0, s1_1_1, 0xE5CE3004, 0xE61C1C12, 0x0ADB37DE, 0x043B1DDE);
	r1 = D(r1, s1_1_1, 0xCAD4D007, 0x0DDD0903, 0xDF0D2C06, 0x23C60611);
	r2 = D(r2, s1_1_1, 0xEFB731FF, 0x0D2916FF, 0x2DE1FBE0, 0xFAC920D9);
	r0 = D(r0, s1_1_2, 0x1B02F3F2, 0x170AE900, 0x21FAFBFB, 0x1D07F3FF);
	r1 = D(r1, s1_1_2, 0xFE16FBF9, 0x0E00FA03, 0x1D0BFDF8, 0x100EF400);
	r2 = D(r2, s1_1_2, 0x16EEF7F9, 0x120AFFFB, 0xF8C8050A, 0xE2C70106);
	r0 = D(r0, s1_2_0, 0xFD0EFA01, 0x0B0DDB0E, 0xFF050303, 0xFF020100);
	r1 = D(r1, s1_2_0, 0xFB091506, 0xFE08FB01, 0x041205FF, 0xFEF3F3F9);
	r2 = D(r2, s1_2_0, 0xFD211201, 0xFD0DFF00, 0xFD0A0F0B, 0x060EF1ED);
	r0 = D(r0, s1_2_1, 0x0707F203, 0xF3D9081C, 0xF813F404, 0xFDFBFB08);
	r1 = D(r1, s1_2_1, 0xE50A08E1, 0x01FD01FE, 0x02170317, 0x0714F105);
	r2 = D(r2, s1_2_1, 0xFE1FFB04, 0x04050702, 0x02F90BF6, 0x0A30ED0B);
	r0 = D(r0, s1_2_2, 0x01030302, 0x1920F4F3, 0x0C02FE02, 0x01040200);
	r1 = D(r1, s1_2_2, 0xFCEFFDFE, 0x0A04FCFE, 0xF5FF0304, 0x0005FDFD);
	r2 = D(r2, s1_2_2, 0x0C0CFCFD, 0x02F8FF03, 0x1A06FA03, 0x0019FD02);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xEF170B00, 0x050E04FC, 0xFDFB0004, 0xEEFAFC05);
	r1 = D(r1, s0_0_0, 0xEDF2FE05, 0xF7070304, 0xF504F9FB, 0xFB01FA04);
	r2 = D(r2, s0_0_0, 0xFC050200, 0x02F70908, 0x05FA060B, 0xFB0DFC07);
	r0 = D(r0, s0_0_1, 0x0AD514FE, 0x01FCFFEE, 0x020E0BF6, 0x29201208);
	r1 = D(r1, s0_0_1, 0xDC0D0BEF, 0x03FA1A02, 0x0BD105FE, 0xFE0C10F5);
	r2 = D(r2, s0_0_1, 0x010101F9, 0x06FDF814, 0x030D05F4, 0xFFEB070D);
	r0 = D(r0, s0_0_2, 0xFE05FF04, 0x07FB0C0F, 0xFB010C08, 0xF9EE12FE);
	r1 = D(r1, s0_0_2, 0xF7F71010, 0x06020AFD, 0x03F90904, 0xFF01FD03);
	r2 = D(r2, s0_0_2, 0xFEFFFB06, 0xFDFD0CE8, 0x010AFD04, 0x0605FEE8);
	r0 = D(r0, s0_1_0, 0x37030A26, 0x14190B01, 0xF8EDFC0B, 0x04F6FE02);
	r1 = D(r1, s0_1_0, 0x180306FA, 0x15FE0F05, 0x101015F8, 0xF9E8FEFD);
	r2 = D(r2, s0_1_0, 0x03191009, 0xF9FCF51C, 0xDDD9FC09, 0xFEEA0009);
	r0 = D(r0, s0_1_1, 0xEA060A63, 0xF3FED8F6, 0x402C0543, 0x16010D0C);
	r1 = D(r1, s0_1_1, 0x58EAC248, 0x18083712, 0xEFE8D23C, 0x1E1DE8F8);
	r2 = D(r2, s0_1_1, 0x1ECB0A18, 0x1E10A40B, 0x4912D8FD, 0xF501DF38);
	r0 = D(r0, s0_1_2, 0x030102F0, 0x00020805, 0xE4EB0E1F, 0xE3FC0D81);
	r1 = D(r1, s0_1_2, 0x1FE2F41A, 0x04FC160C, 0xF40302D8, 0x050805FE);
	r2 = D(r2, s0_1_2, 0xFB0A03F9, 0xFEFDF437, 0xFFEA052A, 0xF4F514C0);
	r0 = D(r0, s0_2_0, 0xF9FA05F5, 0x01FE01D5, 0xF6FDFD0B, 0xFCFFFE0D);
	r1 = D(r1, s0_2_0, 0xEDF6070E, 0x06FD0005, 0x10F906EE, 0x0E03EE03);
	r2 = D(r2, s0_2_0, 0x1EF6080D, 0x010309FA, 0x03F80A1D, 0xF9FCFE0C);
	r0 = D(r0, s0_2_1, 0xF4FF04E2, 0xFA0D14F3, 0xFAFB0DEF, 0xFF02050F);
	r1 = D(r1, s0_2_1, 0xCE0D0720, 0xEF010A09, 0x05F1FCD4, 0x1CF8F1E6);
	r2 = D(r2, s0_2_1, 0xD90B0A2A, 0xFCFDFC24, 0xEF171428, 0x17F5F71F);
	r0 = D(r0, s0_2_2, 0xFF01F819, 0x06FD0E0B, 0xFBFEF8B3, 0xFE00FCD6);
	r1 = D(r1, s0_2_2, 0xE9060581, 0xFFFD0100, 0xF6FE07D6, 0x0203F406);
	r2 = D(r2, s0_2_2, 0xFC04FFE7, 0x01FE0DCD, 0x0BF0FDE9, 0x000B0305);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-7.725e-03, 4.623e-03, -5.545e-03, -2.873e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.529e-04, 7.372e-03, -8.384e-03, 3.660e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-3.603e-03, -4.073e-01, 5.029e-03, 1.171e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(2, 0), f2);
}

//!DESC CuNNy-4x12-BILINEAR-MPV-NVL-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv4
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
#define l0(x, y) V4(conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(0, 0)) + vec2(0.5)) * conv4_pt))
#define l1(x, y) V4(conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(1, 0)) + vec2(0.5)) * conv4_pt))
#define l2(x, y) V4(conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(3, 1) + ivec2(2, 0)) + vec2(0.5)) * conv4_pt))
shared V4 G[3][10][10];
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
			G[2][ay][ax] = l2(x - 1, y - 1);
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
	r0 += M4(-1.290e-02, 7.108e-04, -9.440e-03, -6.677e-03, 1.023e-01, -2.752e-02, 3.175e-02, -8.656e-03, 3.323e-02, -7.760e-04, 6.877e-03, 3.822e-03, -7.614e-03, -1.597e-02, -1.076e-03, -3.676e-03) * s0_0_0;
	r0 += M4(-1.664e-02, -2.068e-02, -2.452e-02, 4.504e-03, -2.446e-01, 1.496e-01, -2.705e-02, -2.310e-02, -2.926e-03, 2.742e-02, -4.801e-04, -4.152e-02, -1.218e-02, -7.308e-03, -4.328e-03, -5.105e-03) * s0_0_1;
	r0 += M4(7.298e-03, -7.941e-04, -6.140e-03, 9.479e-03, 2.716e-02, -9.741e-02, 4.384e-04, 2.045e-02, -5.283e-03, -8.757e-03, -7.047e-03, -1.060e-02, -2.224e-03, -4.189e-03, -2.969e-03, 2.286e-04) * s0_0_2;
	r0 += M4(2.073e-02, -2.179e-02, 7.791e-04, 9.098e-03, -1.330e-02, -2.790e-02, 8.423e-02, -4.163e-02, 1.218e-01, -4.834e-03, 1.587e-01, -3.408e-02, 5.531e-02, -2.102e-02, -1.461e-02, 3.090e-03) * s0_1_0;
	r0 += M4(-5.957e-01, 1.504e-01, 6.448e-02, 9.446e-02, 4.585e-02, 1.257e-01, -2.349e-01, 3.018e-01, 1.760e-01, -6.219e-01, 1.233e-01, 9.685e-02, 1.670e-01, 7.127e-02, 5.029e-02, 3.610e-02) * s0_1_1;
	r0 += M4(-1.581e-02, 7.972e-02, 2.486e-03, 1.294e-01, -2.606e-03, -4.830e-02, 4.845e-02, -1.367e-01, -3.180e-02, -1.329e-02, -4.202e-03, -3.314e-02, 2.915e-03, 2.208e-02, -1.524e-04, 4.675e-03) * s0_1_2;
	r0 += M4(-7.905e-03, -2.987e-03, -2.487e-02, -4.507e-03, -2.481e-03, 5.455e-03, -3.073e-02, -9.628e-03, -4.818e-02, -4.274e-03, 4.153e-02, -1.364e-03, 1.223e-01, -3.246e-02, 8.101e-02, -4.849e-02) * s0_2_0;
	r0 += M4(-2.715e-03, -1.619e-02, 1.343e-01, 6.331e-02, -3.238e-02, -1.814e-02, -2.910e-04, -2.022e-02, -3.411e-03, -2.515e-02, 1.697e-01, 1.180e-01, -3.821e-02, 7.103e-02, 2.080e-02, -6.745e-01) * s0_2_1;
	r0 += M4(-7.159e-03, -4.101e-02, -4.133e-02, 6.452e-02, -7.337e-04, 6.194e-04, -6.812e-03, -2.202e-02, -1.210e-02, 6.092e-03, -9.719e-03, -1.810e-03, 5.301e-03, -5.707e-02, -4.244e-02, -3.158e-02) * s0_2_2;
	r0 += M4(-3.541e-02, 1.630e-03, -1.772e-03, 4.053e-03, 3.853e-02, 1.729e-02, 2.863e-02, -7.748e-04, -2.460e-02, -1.924e-02, -2.051e-02, -1.802e-03, -3.278e-02, -2.044e-02, -2.663e-02, 1.162e-02) * s1_0_0;
	r0 += M4(-3.682e-02, -4.455e-02, 1.825e-02, 7.242e-03, -3.284e-02, -2.836e-02, 3.211e-02, 3.162e-02, 9.167e-02, 4.580e-02, -1.429e-02, -1.679e-02, 1.189e-03, 4.617e-03, -5.067e-02, -5.512e-02) * s1_0_1;
	r0 += M4(-2.009e-03, -3.333e-02, -1.820e-03, 1.089e-02, 2.037e-02, 2.941e-02, 2.561e-03, 2.320e-02, -6.827e-03, 1.718e-02, 7.896e-03, -2.408e-02, -5.730e-03, -2.223e-02, 2.130e-02, -9.977e-03) * s1_0_2;
	r0 += M4(1.176e-01, -7.786e-03, 1.181e-02, 1.204e-02, 8.033e-03, 4.089e-02, 7.232e-03, 1.776e-02, 7.589e-02, -2.620e-02, 2.309e-02, -3.338e-02, 2.146e-02, -3.403e-02, 3.233e-02, -2.961e-02) * s1_1_0;
	r0 += M4(2.153e-01, 3.053e-01, -2.446e-01, -1.938e-01, -3.412e-01, -4.461e-01, -3.995e-01, -4.002e-01, -3.866e-01, 1.986e-01, 1.214e-01, 2.627e-01, 2.295e-01, 2.272e-01, 2.241e-01, 2.234e-01) * s1_1_1;
	r0 += M4(-1.406e-02, 2.257e-02, 1.886e-02, -6.470e-02, 3.775e-02, 7.076e-02, 3.182e-02, 1.508e-02, 2.120e-02, -2.319e-01, -5.251e-02, -8.374e-02, -3.334e-02, 3.539e-02, -2.836e-02, 3.038e-02) * s1_1_2;
	r0 += M4(-3.162e-02, -7.704e-03, -2.555e-03, -1.375e-02, 5.327e-02, -7.784e-03, 7.461e-02, 3.919e-02, 7.770e-03, -8.140e-03, 5.396e-02, 8.563e-04, -2.155e-02, 6.779e-03, -3.536e-02, -2.534e-02) * s1_2_0;
	r0 += M4(-2.690e-02, -5.115e-02, 9.643e-02, 6.174e-02, -1.254e-04, 7.104e-02, -3.453e-02, 9.330e-03, 2.283e-02, -4.699e-03, -1.989e-01, -4.291e-04, -2.966e-02, -3.343e-02, 2.706e-02, 2.093e-02) * s1_2_1;
	r0 += M4(-5.358e-03, -1.004e-02, -1.496e-02, 2.251e-02, -6.968e-04, -4.058e-03, 4.194e-02, 7.557e-02, 1.142e-02, 4.524e-02, 4.457e-02, -3.188e-02, 1.547e-02, -1.031e-02, -1.754e-02, -1.983e-02) * s1_2_2;
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2];
	r0 += M4(-9.349e-03, -4.494e-03, -1.151e-02, -7.444e-03, 3.466e-02, 1.861e-02, 1.307e-02, -4.424e-03, -5.748e-02, 2.575e-02, -9.624e-05, -1.234e-02, 4.018e-02, 5.892e-03, 1.997e-03, -2.822e-03) * s0_0_0;
	r0 += M4(1.433e-01, 1.205e-01, 2.078e-02, 7.963e-03, 1.015e-01, 9.941e-02, 4.503e-02, 5.901e-02, -1.961e-02, -1.646e-01, -1.270e-02, 3.722e-02, 1.073e-01, 1.280e-01, -1.079e-02, 1.213e-02) * s0_0_1;
	r0 += M4(-1.621e-02, 1.315e-01, 8.707e-03, -9.066e-03, 1.754e-02, 3.186e-02, -1.999e-03, -4.635e-03, -2.814e-03, 3.811e-02, -3.816e-03, 1.374e-02, 3.693e-04, 3.024e-02, 6.458e-03, -3.268e-03) * s0_0_2;
	r0 += M4(-2.429e-02, -5.872e-04, -1.383e-02, -2.337e-02, 8.248e-02, 1.647e-02, 8.991e-02, 1.589e-02, -6.767e-02, 2.740e-02, -1.353e-01, 6.323e-02, -1.519e-01, 4.721e-02, -4.288e-02, 1.708e-02) * s0_1_0;
	r0 += M4(5.357e-02, 5.789e-02, -7.065e-01, 8.975e-02, 3.989e-01, 3.979e-01, 4.178e-01, 4.322e-01, 3.101e-01, 5.826e-02, 2.122e-01, -3.550e-01, -1.811e-01, -4.129e-01, 2.624e-01, 1.285e-01) * s0_1_1;
	r0 += M4(2.676e-02, 1.411e-01, 8.371e-03, 8.742e-02, 3.547e-02, 1.214e-01, 3.138e-02, 1.231e-01, -1.217e-02, 1.008e-01, 6.972e-03, 1.294e-01, 4.540e-03, 3.148e-03, -1.739e-02, 7.377e-02) * s0_1_2;
	r0 += M4(-4.135e-03, -3.029e-03, 7.807e-03, -5.373e-03, 2.397e-02, -1.576e-02, 5.130e-02, 2.813e-03, -2.415e-02, 3.017e-03, -3.357e-02, 3.657e-03, 2.000e-02, -3.437e-04, -2.293e-02, 1.598e-02) * s0_2_0;
	r0 += M4(2.053e-03, 5.108e-03, 2.499e-02, 8.374e-03, 7.409e-02, 8.839e-02, 1.066e-01, 1.097e-01, -2.276e-02, -3.650e-02, 2.362e-02, 6.786e-03, -6.691e-03, 2.729e-02, -6.877e-02, -5.362e-02) * s0_2_1;
	r0 += M4(-3.412e-03, -6.479e-03, 3.126e-03, 8.842e-03, -1.226e-02, 9.805e-03, 2.421e-03, 5.379e-02, -6.491e-04, -1.208e-02, -1.765e-02, -1.488e-02, 6.554e-03, -5.029e-03, 2.764e-03, -1.065e-02) * s0_2_2;
	r0 += V4(-5.875e-03, -6.241e-03, -5.938e-03, -5.965e-03);
	r0 = tanh(r0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
