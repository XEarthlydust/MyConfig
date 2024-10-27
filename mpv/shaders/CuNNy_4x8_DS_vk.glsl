// CuNNy 4x8 BILINEAR MPV NVL
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


//!DESC CuNNy-4x8-BILINEAR-MPV-NVL-in
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
	r0 += V4(9.216e-02, 8.102e-02, 1.491e-02, 2.275e-02) * s0_0_0;
	r1 += V4(-9.023e-03, 2.615e-02, -5.113e-02, -1.214e-02) * s0_0_0;
	r0 += V4(-1.860e-01, -1.164e-01, -8.836e-02, -1.075e-02) * s0_0_1;
	r1 += V4(2.536e-01, 7.402e-01, 3.603e-02, 6.519e-02) * s0_0_1;
	r0 += V4(5.720e-02, 4.014e-02, 8.219e-02, -1.486e-02) * s0_0_2;
	r1 += V4(4.282e-01, 5.161e-02, 1.300e-02, 2.451e-03) * s0_0_2;
	r0 += V4(-6.747e-02, -9.409e-02, 1.213e-01, -7.544e-02) * s0_1_0;
	r1 += V4(-1.309e-01, -3.588e-02, 5.162e-02, -1.663e-02) * s0_1_0;
	r0 += V4(-1.859e+00, -6.738e-01, -7.053e-01, -2.757e-01) * s0_1_1;
	r1 += V4(-7.024e-01, -7.019e-01, 6.699e-01, 6.802e-01) * s0_1_1;
	r0 += V4(5.605e-01, 1.832e-01, -6.270e-02, -3.350e-01) * s0_1_2;
	r1 += V4(1.255e-01, -8.246e-02, -7.205e-01, -2.543e-01) * s0_1_2;
	r0 += V4(3.103e-02, 3.433e-02, 5.254e-01, 3.895e-02) * s0_2_0;
	r1 += V4(1.636e-01, 2.192e-02, -1.399e-02, -3.022e-03) * s0_2_0;
	r0 += V4(1.930e-01, 8.080e-02, 1.170e-01, 7.396e-01) * s0_2_1;
	r1 += V4(-9.460e-02, -5.838e-02, 1.964e-02, -2.117e-02) * s0_2_1;
	r0 += V4(-1.060e-02, 4.656e-01, -5.919e-03, -6.726e-02) * s0_2_2;
	r1 += V4(-4.792e-02, 3.793e-02, -8.300e-03, 1.347e-02) * s0_2_2;
	r0 += V4(1.380e-02, -3.174e-04, -5.290e-03, -2.773e-03);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-6.384e-04, 1.379e-03, 2.051e-03, -4.075e-04);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-4x8-BILINEAR-MPV-NVL-conv1
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
	r0 = D(r0, s0_0_0, 0x01FF21FD, 0xDF0FF80B, 0xF8F90B08, 0x240DE6E8);
	r1 = D(r1, s0_0_0, 0x62E9083C, 0xFBFD2001, 0xED01F606, 0x020AB9FB);
	r0 = D(r0, s0_0_1, 0xFBEC0813, 0x3A0BCD62, 0xF5FB0006, 0x2AF3E120);
	r1 = D(r1, s0_0_1, 0xB8813004, 0x2508EC17, 0x16020204, 0x9B47A1E5);
	r0 = D(r0, s0_0_2, 0xF1331EF7, 0x20F6FD2B, 0xF10F09FB, 0xEDFAF5FC);
	r1 = D(r1, s0_0_2, 0xFAFD1504, 0xFF121EF1, 0xFA0B02FD, 0x35530CF2);
	r0 = D(r0, s0_1_0, 0x28FEEB16, 0xFAF7CB70, 0x3205EC00, 0x0C07E5FA);
	r1 = D(r1, s0_1_0, 0xD007FBF4, 0x19F70124, 0xEB0500FF, 0x13EEE605);
	r0 = D(r0, s0_1_1, 0xD807EED3, 0x5500457F, 0x22FC0A1E, 0xAA818191);
	r1 = D(r1, s0_1_1, 0xFDBB70E5, 0x35E90DE4, 0x480309FF, 0xEB0FC903);
	r0 = D(r0, s0_1_2, 0x020B1AE8, 0x28E0F32F, 0x04F116F3, 0x0EEBE70A);
	r1 = D(r1, s0_1_2, 0xFFEC26FA, 0x12CC0DE6, 0xE402FFF7, 0xF16D0EFD);
	r0 = D(r0, s0_2_0, 0xFCFD1502, 0xFF0AE817, 0x060AFC09, 0xFE04FBDB);
	r1 = D(r1, s0_2_0, 0x0C1111FE, 0xF7FC1111, 0xFC00FDFA, 0x05FC05FF);
	r0 = D(r0, s0_2_1, 0xF4FF02F8, 0x2900E90E, 0xFD060BFD, 0xFD1ECE4F);
	r1 = D(r1, s0_2_1, 0xFD11FD00, 0xE61C16FF, 0xFB0610F6, 0x120CEE03);
	r0 = D(r0, s0_2_2, 0xFC0BFD01, 0x1DEAFC17, 0xFEFAFBFD, 0x09030B0E);
	r1 = D(r1, s0_2_2, 0xF3F70812, 0xF10CFD01, 0xFFFA09F3, 0x03F40DFD);
	r0 = D(r0, s1_0_0, 0xF1230CF4, 0xDA0307F9, 0xEE1511EF, 0xE50F0707);
	r1 = D(r1, s1_0_0, 0xEA413294, 0xF50F13EB, 0xE6080003, 0xF1B8000D);
	r0 = D(r0, s1_0_1, 0xE6ED07FD, 0x811422F5, 0x04FC08FF, 0x170408FA);
	r1 = D(r1, s1_0_1, 0x26C308F1, 0xD3080FEE, 0xFF0106F8, 0xEFD5C428);
	r0 = D(r0, s1_0_2, 0x23F914F8, 0x90200D02, 0x0EFE0901, 0xF31901FC);
	r1 = D(r1, s1_0_2, 0xF6092310, 0x23F40AFD, 0x14FD0100, 0x0DF108FF);
	r0 = D(r0, s1_1_0, 0xD54C06FF, 0xD474090B, 0x195419F4, 0xF881040F);
	r1 = D(r1, s1_1_0, 0x30D0B5FE, 0xA5611AE8, 0x11070F0A, 0x00ECCE3B);
	r0 = D(r0, s1_1_1, 0x1E523BC8, 0x817A7E47, 0xB7332CF3, 0x2CC481A8);
	r1 = D(r1, s1_1_1, 0x1FDF35CA, 0x282054C1, 0x0B0003E1, 0xF4DF0442);
	r0 = D(r0, s1_1_2, 0x1BF8F00C, 0x813E2ECC, 0x31F6F810, 0xEC000F29);
	r1 = D(r1, s1_1_2, 0xC214FFE3, 0x52E6F513, 0x1C04FF08, 0x30EAA727);
	r0 = D(r0, s1_2_0, 0xE1FFF40C, 0xAD30F3FB, 0xDE12F4FE, 0x2EE4EB32);
	r1 = D(r1, s1_2_0, 0xFEF412F9, 0xE7FE1EF9, 0x0E11090B, 0xE9F8E41C);
	r0 = D(r0, s1_2_1, 0x071870F7, 0x93226EED, 0x130626E6, 0x01198140);
	r1 = D(r1, s1_2_1, 0xEE4D40A6, 0x0FF418C9, 0x1DEBEA02, 0xE03A1CFE);
	r0 = D(r0, s1_2_2, 0x12010BFB, 0x8D3BFDE4, 0x0A0001FD, 0xDB03EAE1);
	r1 = D(r1, s1_2_2, 0x000F30CB, 0xFE0010F3, 0x17FD0919, 0x2FF3F8FF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-7.236e-03, -6.856e-03, 2.665e-02, 5.649e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(2.059e-02, -2.081e-02, -4.092e-01, 2.875e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-4x8-BILINEAR-MPV-NVL-conv2
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
	r0 = D(r0, s0_0_0, 0xFA0110F9, 0x1A051614, 0x10010908, 0x051710F2);
	r1 = D(r1, s0_0_0, 0x35FDFAE3, 0x10061009, 0xE700281C, 0xF0FB0408);
	r0 = D(r0, s0_0_1, 0xE6021F18, 0xDEFCE6DA, 0x1A0304FD, 0xDC49310A);
	r1 = D(r1, s0_0_1, 0xE9F9FF17, 0x17FCF918, 0xF5E1EF3A, 0xDF3329C2);
	r0 = D(r0, s0_0_2, 0xFFEC0FFB, 0x0D393D07, 0x060406F4, 0xF3AAEBE9);
	r1 = D(r1, s0_0_2, 0x1DD11201, 0x10F3F7FF, 0x16D404F1, 0x0A22FBED);
	r0 = D(r0, s0_1_0, 0xF9022FEF, 0xFD05F21D, 0x17FC1104, 0x14E1F8FB);
	r1 = D(r1, s0_1_0, 0xE4D5F81F, 0x06FE0414, 0xC7173FE2, 0xFAF6140A);
	r0 = D(r0, s0_1_1, 0xE14C67F6, 0x08985AD8, 0x029C8130, 0xE80BD21B);
	r1 = D(r1, s0_1_1, 0xAF2E2718, 0x19FB1D10, 0xDCE8B029, 0x0C3F0AC2);
	r0 = D(r0, s0_1_2, 0xEE021208, 0x2BD424F5, 0x17191105, 0xD24540F9);
	r1 = D(r1, s0_1_2, 0x01273005, 0x09647381, 0x1DEC1014, 0x141A1DA1);
	r0 = D(r0, s0_2_0, 0x06FB10F4, 0x0414230D, 0x000E0DFB, 0x0DFFF3FC);
	r1 = D(r1, s0_2_0, 0x8125300F, 0x010A1509, 0xDDE4F1F9, 0x0209F8F8);
	r0 = D(r0, s0_2_1, 0xFA022F08, 0x140F0A0B, 0x18090C0C, 0x1CD2F303);
	r1 = D(r1, s0_2_1, 0xDCEC2BDC, 0x04FD0313, 0xC90B23F1, 0x02F31B03);
	r0 = D(r0, s0_2_2, 0x17FD1109, 0xF6E4EAFE, 0x020606FA, 0x0B141302);
	r1 = D(r1, s0_2_2, 0x0ED202F2, 0x07F107F7, 0x0A000A00, 0x0FDF0E06);
	r0 = D(r0, s1_0_0, 0xFE1AFF00, 0xECECF606, 0x037FF8FF, 0x0A780BE3);
	r1 = D(r1, s1_0_0, 0xF6461B11, 0xF6F8F500, 0x0AC5F200, 0xFF2DF3F7);
	r0 = D(r0, s1_0_1, 0xFB81EC04, 0xFA4832FC, 0xF97FFA05, 0x0DE1E6E8);
	r1 = D(r1, s1_0_1, 0xDE0ADDFC, 0xF7F4F3FA, 0x0811D8FF, 0x11814518);
	r0 = D(r0, s1_0_2, 0xFE350B00, 0x163717FA, 0xFB7F0102, 0x16E6F1E1);
	r1 = D(r1, s1_0_2, 0xFC3B140D, 0x06812BFB, 0x0C7F0201, 0x0B810D1A);
	r0 = D(r0, s1_1_0, 0xF9E51102, 0x06D2F2FD, 0xFE431409, 0x00810BF5);
	r1 = D(r1, s1_1_0, 0xF081DCFD, 0xFDF0FA00, 0xF82C11F4, 0xFBE60107);
	r0 = D(r0, s1_1_1, 0xF00EEAEE, 0x5FCA0F01, 0x057F08FC, 0xE930E6E3);
	r1 = D(r1, s1_1_1, 0xE447F1FF, 0x06FE0B01, 0x068104FE, 0x5F3ECC00);
	r0 = D(r0, s1_1_2, 0x060720F4, 0xDDC8AE32, 0xFE73FEFB, 0x103E04E8);
	r1 = D(r1, s1_1_2, 0xDB5B24EA, 0x0881DB1C, 0x045724E8, 0x1CF0B529);
	r0 = D(r0, s1_2_0, 0xF8050AFF, 0xF827FB08, 0x0A1AF2FD, 0x17F1F7E8);
	r1 = D(r1, s1_2_0, 0xB12C08EE, 0xFFCEFA04, 0x261FEDF6, 0x01D803EB);
	r0 = D(r0, s1_2_1, 0xFE251EEE, 0x1020F505, 0xED44F700, 0x091212FA);
	r1 = D(r1, s1_2_1, 0xEA7F3EFD, 0x050BE611, 0x011AECFA, 0xF86F161D);
	r0 = D(r0, s1_2_2, 0xF6F305FE, 0x0AEC0E0B, 0x00FDFCFF, 0x1B04FCF2);
	r1 = D(r1, s1_2_2, 0xD1D9EA24, 0x09DBF20F, 0x0C510DF8, 0x255E2FFB);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.108e-02, 1.971e-02, -4.245e-03, -1.601e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(2.867e-02, -3.216e-02, 3.060e-02, -5.530e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-4x8-BILINEAR-MPV-NVL-conv3
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
	r0 = D(r0, s0_0_0, 0x16FDFB16, 0xF60AFD00, 0x04F70A04, 0x09D91105);
	r1 = D(r1, s0_0_0, 0x22070A0E, 0xFA14FF01, 0xE204E6C2, 0xFD0DEFF0);
	r0 = D(r0, s0_0_1, 0x20340205, 0xF2FCF307, 0x00020117, 0x15071C05);
	r1 = D(r1, s0_0_1, 0x294B090B, 0xEFECFBF5, 0x1126FFFB, 0x0313EA26);
	r0 = D(r0, s0_0_2, 0xF70303FA, 0xF0060106, 0xF8090502, 0xFBF50EEF);
	r1 = D(r1, s0_0_2, 0x0CED0711, 0x0503FF14, 0x0711F8FF, 0x0017F807);
	r0 = D(r0, s0_1_0, 0x160D010E, 0x09000018, 0x15FF0416, 0xEB0F22DE);
	r1 = D(r1, s0_1_0, 0x290B031A, 0x08E21217, 0xEFECFCC5, 0x0A2FD115);
	r0 = D(r0, s0_1_1, 0xEF310FDC, 0xF70AF724, 0xFA47E4DC, 0xEB512081);
	r1 = D(r1, s0_1_1, 0xE4D60DFE, 0xF8090149, 0x44490FFC, 0x31F2D54E);
	r0 = D(r0, s0_1_2, 0x04020311, 0x123C0FF7, 0x28270E03, 0x1F121CE6);
	r1 = D(r1, s0_1_2, 0x21281701, 0xF8EBEE1D, 0x012C09F3, 0xF6E5F8ED);
	r0 = D(r0, s0_2_0, 0x0D09F707, 0x0306FA05, 0x14FF020F, 0x25F11D06);
	r1 = D(r1, s0_2_0, 0x04FEF411, 0x010CF0FF, 0xEB0709EF, 0xEB14F40B);
	r0 = D(r0, s0_2_1, 0x13FE0314, 0xCC4515F9, 0x0F0A170B, 0xDE211DF3);
	r1 = D(r1, s0_2_1, 0x1FFDFE02, 0x15E1FB1A, 0xFBF2F723, 0x150ADF03);
	r0 = D(r0, s0_2_2, 0x09FD04FE, 0xF5EA011C, 0x0DF1040F, 0x03F20913);
	r1 = D(r1, s0_2_2, 0x20FD0A16, 0x04160800, 0xF608FBF7, 0x030DFCF9);
	r0 = D(r0, s1_0_0, 0xDEFFE502, 0x05F403F9, 0xFAF8F9FA, 0xE6F5FB0F);
	r1 = D(r1, s1_0_0, 0xDEECDEEC, 0x0A0214FF, 0xF7D9F9FB, 0x02F7FBFA);
	r0 = D(r0, s1_0_1, 0xF9E1F5F5, 0x0900FB0C, 0x05FFF022, 0xF8B6FEE0);
	r1 = D(r1, s1_0_1, 0xEC09E1E3, 0x06180118, 0xDDE41BE0, 0xFCF10CD8);
	r0 = D(r0, s1_0_2, 0x0108FC0B, 0x0404030B, 0x000800F4, 0xFE0603FE);
	r1 = D(r1, s1_0_2, 0x00F907D5, 0xF90905F9, 0x0808FB24, 0x06E1FF0F);
	r0 = D(r0, s1_1_0, 0xF3FDDD07, 0xF3F2D4FD, 0xEBF6E301, 0xD4FFD120);
	r1 = D(r1, s1_1_0, 0xE8F8E0F3, 0xFEF1DAFC, 0x06D30DDE, 0x0304E802);
	r0 = D(r0, s1_1_1, 0xED20F61F, 0xEEF5C708, 0xED1CCE08, 0xD7BE039D);
	r1 = D(r1, s1_1_1, 0xF527D2EF, 0xF6ED140D, 0xDCCA23E6, 0x084A260C);
	r0 = D(r0, s1_1_2, 0x08FFF700, 0xEEE5FB00, 0xF1DEFA11, 0xEBBD04E3);
	r1 = D(r1, s1_1_2, 0xE8F3FEF2, 0x0C1904FA, 0xFE100C21, 0x080A0203);
	r0 = D(r0, s1_2_0, 0xEDFD0203, 0xF2F2C706, 0xEBF8FB02, 0xEBEBFA07);
	r1 = D(r1, s1_2_0, 0xFA000802, 0x0B041606, 0xCB0002FD, 0x02FA0C03);
	r0 = D(r0, s1_2_1, 0xF0F702F4, 0xFF05E518, 0xFB01FE06, 0xE8FDFC1E);
	r1 = D(r1, s1_2_1, 0xE8F706FA, 0xFEFE00F0, 0xDAF2030F, 0xECFF1402);
	r0 = D(r0, s1_2_2, 0x01FBFDFF, 0xF9FA0107, 0xEF03FEF8, 0xE7EFFF02);
	r1 = D(r1, s1_2_2, 0xECF503EF, 0x06FDFE08, 0xF80306EB, 0x05FD0101);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.215e-02, 7.080e-03, -1.067e-02, -4.607e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.599e-02, 6.042e-02, -7.649e-03, 1.197e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-4x8-BILINEAR-MPV-NVL-conv4
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
	r0 = D(r0, s0_0_0, 0xED07DDF5, 0x03FD0CFE, 0xFD10D6F8, 0x04F91D01);
	r1 = D(r1, s0_0_0, 0xEE10DCFB, 0xFE04F9FE, 0xE2F5EBF2, 0x030016FD);
	r0 = D(r0, s0_0_1, 0xE0EB09FD, 0xFFFD02FB, 0xE7FCE6DC, 0xF9F6FEFB);
	r1 = D(r1, s0_0_1, 0xD10DF20E, 0xFF03F6FE, 0xC302E2CB, 0xCF21B301);
	r0 = D(r0, s0_0_2, 0x0D150700, 0x01F70900, 0x01FC0014, 0x02FF0204);
	r1 = D(r1, s0_0_2, 0x01FC0103, 0xFE020204, 0x190B09FC, 0xE9FC0804);
	r0 = D(r0, s0_1_0, 0xD00EFBEB, 0x010802F9, 0xF9F7F6EE, 0xD4CDBA0A);
	r1 = D(r1, s0_1_0, 0xDECC0622, 0xF6FCE905, 0xAF0EEEEC, 0x010905FB);
	r0 = D(r0, s0_1_1, 0xEAFCFEEC, 0xD4AECD0B, 0xE6E9EBFB, 0xD0F42509);
	r1 = D(r1, s0_1_1, 0xD00335A1, 0x25E5F3E8, 0xD112050B, 0xCFB62EC7);
	r0 = D(r0, s0_1_2, 0xC8F8E9EF, 0xCB071011, 0x11F3EEFF, 0x01FAFF03);
	r1 = D(r1, s0_1_2, 0x04F4000D, 0xFBFD0302, 0xDDE7EEE7, 0xE5050A0E);
	r0 = D(r0, s0_2_0, 0xFEE4F8F2, 0x03FF06F9, 0x00ECF402, 0xFD07091C);
	r1 = D(r1, s0_2_0, 0x07F8FD05, 0x0004FE08, 0xB2E7DCFF, 0x01FEFFF9);
	r0 = D(r0, s0_2_1, 0x0ADFE6F2, 0xE62108CE, 0xFFF8DDD6, 0xEC1901B1);
	r1 = D(r1, s0_2_1, 0x0CF4FA09, 0xFE0105EF, 0xFA16F9EC, 0x0BFBFB07);
	r0 = D(r0, s0_2_2, 0xE6FBE9E8, 0x04F7000B, 0x06F9F11C, 0x05FA000E);
	r1 = D(r1, s0_2_2, 0x02020006, 0xFD00FFFB, 0xEAFAF615, 0x08F8FF0A);
	r0 = D(r0, s1_0_0, 0xC81BE817, 0xFE00FE00, 0xEEEFF4EE, 0xFDFC01FE);
	r1 = D(r1, s1_0_0, 0x06030304, 0x0AFE0605, 0xF01AE105, 0xFEFEFF02);
	r0 = D(r0, s1_0_1, 0xFCFDD3F1, 0xFF070101, 0xF1E505EA, 0xFC0CFEFE);
	r1 = D(r1, s1_0_1, 0x15F40400, 0x0DF80601, 0xF2F7C8FA, 0x19100508);
	r0 = D(r0, s1_0_2, 0xFA03F5F6, 0xFB02FE00, 0xFAE3E4F3, 0xFF00FEFF);
	r1 = D(r1, s1_0_2, 0xFC0400FF, 0xFEFF0100, 0xFBE5CEF9, 0x00F101FE);
	r0 = D(r0, s1_1_0, 0xED05DE08, 0xFEFB01F9, 0xF0EC0CFE, 0x190308F3);
	r1 = D(r1, s1_1_0, 0x150407B3, 0x2000F9F5, 0x0F0EC1EE, 0xFD010003);
	r0 = D(r0, s1_1_1, 0xF2E5B8FB, 0x5CEB091E, 0xDF1BED01, 0x57B00231);
	r1 = D(r1, s1_1_1, 0x58AA0528, 0xD80C4103, 0x0A02C508, 0x54CE09C8);
	r0 = D(r0, s1_1_2, 0xEDFEB805, 0x17F00705, 0xD9FB00D5, 0x020202FB);
	r1 = D(r1, s1_1_2, 0x03FB01FB, 0xFD000B05, 0xF2ED8D04, 0x19F3070B);
	r0 = D(r0, s1_2_0, 0x27FFE2D4, 0xFD02FE16, 0xF8EFEF06, 0x000004E2);
	r1 = D(r1, s1_2_0, 0xFCFB0115, 0x02FD0200, 0xE1F1ABEE, 0x00000007);
	r0 = D(r0, s1_2_1, 0x03F7ED11, 0x14DD0AB3, 0x0B00FAF5, 0x17D006F2);
	r1 = D(r1, s1_2_1, 0xFEEBFFF8, 0x010310F9, 0xDC0EBA0D, 0xFEF20103);
	r0 = D(r0, s1_2_2, 0x19E7D7FC, 0x01F60209, 0xE5EFE4F5, 0xFDFAFFFD);
	r1 = D(r1, s1_2_2, 0xFEFEFFFE, 0x06FD0105, 0xFEEAAC1A, 0xFBFDFF07);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.190e-01, -1.199e-02, -1.602e-01, -9.426e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-9.551e-03, 4.344e-02, -5.520e-02, -1.095e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-4x8-BILINEAR-MPV-NVL-out-shuffle
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
#define l0(x, y) V4(conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv4_pt))
#define l1(x, y) V4(conv4_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv4_pt))
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
	r0 += M4(-1.283e-01, 2.702e-01, -1.650e-01, 1.919e-01, 6.258e-02, 8.808e-03, 6.262e-03, 1.041e-02, -2.610e-01, 2.618e-01, 2.089e-01, 2.531e-01, 7.721e-03, -4.148e-03, 1.749e-02, 6.490e-03) * s0_0_0;
	r0 += M4(-3.160e-01, 1.413e-01, -1.796e-01, 1.880e-01, 9.928e-02, 7.524e-03, 9.380e-03, 2.700e-02, 6.947e-02, -9.565e-02, 1.442e-01, 9.026e-02, 7.019e-03, 1.082e-01, 8.625e-03, -1.753e-03) * s0_0_1;
	r0 += M4(-5.848e-02, -1.381e-01, -2.196e-02, -6.602e-02, -1.415e-02, 1.296e-02, 4.843e-03, 2.484e-02, -1.810e-01, 3.248e-01, -3.747e-01, -7.734e-02, 7.821e-03, 5.390e-02, 1.645e-02, -4.743e-03) * s0_0_2;
	r0 += M4(-2.425e-01, 2.531e-01, -1.124e-01, 2.218e-01, 8.124e-02, 2.574e-02, 1.694e-02, 3.968e-02, 2.199e-01, -1.274e-01, -1.247e-01, 8.744e-02, 5.751e-02, -3.390e-03, 8.865e-02, -1.990e-02) * s0_1_0;
	r0 += M4(-3.986e-01, -1.992e-01, -8.617e-02, -4.762e-02, 2.501e-01, 1.173e-01, 1.307e-01, -9.126e-01, 7.738e-02, 1.449e-02, 5.753e-02, -2.265e-01, 1.548e-01, 2.484e-01, -9.151e-01, 1.578e-01) * s0_1_1;
	r0 += M4(2.883e-01, 1.157e-01, 5.957e-02, -1.636e-01, -9.279e-03, 4.651e-02, -2.668e-02, 6.376e-02, 3.606e-01, -2.738e-01, -9.617e-02, 2.480e-01, 1.242e-02, 1.103e-01, 3.748e-02, 4.096e-03) * s0_1_2;
	r0 += M4(1.637e-01, 2.841e-01, 4.172e-03, -1.037e-01, -1.267e-02, 3.717e-03, 2.134e-03, 2.752e-02, 1.136e-01, -4.483e-02, 2.195e-01, -2.577e-01, -7.668e-04, 4.775e-03, 2.269e-02, -4.854e-03) * s0_2_0;
	r0 += M4(6.588e-03, -1.362e-01, -2.672e-01, 2.319e-01, 6.427e-03, -2.501e-02, 6.598e-02, 8.006e-02, -3.827e-02, 1.666e-01, 1.408e-01, -2.501e-01, -3.357e-02, -1.304e-02, 6.517e-02, 2.726e-02) * s0_2_1;
	r0 += M4(1.303e-01, 2.618e-01, 9.736e-03, -1.250e-01, 5.561e-03, -1.880e-03, -6.879e-03, 2.580e-02, 1.639e-01, -2.352e-01, 2.353e-01, -3.010e-01, -2.178e-03, -9.357e-03, 1.790e-02, 4.099e-03) * s0_2_2;
	r0 += M4(1.849e-02, -5.898e-03, -6.455e-03, 3.371e-03, 4.969e-02, 3.772e-02, 4.398e-02, -3.941e-03, -2.502e-01, 2.618e-01, -4.295e-03, 1.163e-01, 2.204e-02, 2.779e-02, -2.141e-03, 7.479e-04) * s1_0_0;
	r0 += M4(7.104e-02, 4.871e-02, -2.360e-02, -5.168e-03, -6.009e-02, -6.256e-02, 1.936e-02, 2.589e-02, -6.717e-02, 5.798e-03, 2.348e-02, 6.916e-02, 5.461e-02, 7.444e-02, 1.274e-02, -9.515e-03) * s1_0_1;
	r0 += M4(9.162e-03, -3.227e-03, -5.824e-03, -1.327e-02, 4.032e-02, 5.698e-02, -1.813e-02, 2.439e-02, -2.004e-01, 8.820e-02, -4.201e-01, -2.840e-01, 8.349e-04, 3.092e-02, 8.416e-04, -5.874e-04) * s1_0_2;
	r0 += M4(7.989e-02, -2.947e-02, 4.846e-02, -1.134e-02, -8.277e-02, -3.825e-03, -9.078e-02, 6.973e-03, -3.109e-01, 2.905e-01, 8.542e-02, 4.678e-02, 4.504e-02, 4.028e-02, 1.171e-01, 3.650e-02) * s1_1_0;
	r0 += M4(-9.078e-01, 1.294e-01, 1.521e-01, 2.358e-01, -3.727e-01, -3.643e-01, -3.857e-01, -3.841e-01, -6.558e-02, -8.708e-02, 2.545e-01, -1.011e-01, 9.076e-02, -9.358e-01, 2.144e-01, 1.204e-01) * s1_1_1;
	r0 += M4(1.025e-02, 2.652e-02, -5.642e-03, 1.101e-01, 3.630e-02, -4.694e-02, 4.803e-02, -4.369e-02, 1.006e-01, -2.145e-01, 6.099e-02, -4.442e-02, -4.806e-03, 6.470e-02, 6.065e-03, 4.677e-02) * s1_1_2;
	r0 += M4(1.219e-02, 6.955e-03, 9.872e-03, -2.084e-03, 3.073e-02, -2.170e-02, 4.444e-02, 9.673e-03, 3.791e-01, -1.050e-01, -1.881e-01, -3.995e-02, 8.528e-03, 7.498e-03, 5.701e-02, -5.298e-03) * s1_2_0;
	r0 += M4(7.121e-03, -5.079e-03, 1.580e-02, 9.692e-02, 4.773e-02, 5.219e-02, -2.497e-02, -2.218e-02, -1.458e-01, 3.219e-02, -6.784e-02, -5.026e-01, 2.411e-02, 4.266e-02, 8.815e-02, 1.427e-03) * s1_2_1;
	r0 += M4(8.635e-03, -8.826e-03, -1.389e-02, 7.431e-02, -3.254e-02, 1.901e-02, 1.532e-02, 4.929e-02, -9.466e-02, -2.702e-01, 4.940e-01, 3.776e-02, 1.351e-03, 2.595e-02, 3.054e-03, 1.178e-02) * s1_2_2;
	r0 += V4(3.095e-02, 3.021e-02, 3.154e-02, 3.052e-02);
	r0 = tanh(r0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
