// CuNNy 1x8 BILINEAR MPV NVL
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


//!DESC CuNNy-1x8-BILINEAR-MPV-NVL-in
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
	r0 += V4(1.049e-01, -2.151e-02, -4.227e-03, 6.274e-02) * s0_0_0;
	r1 += V4(1.616e-01, -1.053e-01, -4.107e-03, 6.665e-03) * s0_0_0;
	r0 += V4(-8.813e-02, 2.848e-02, 1.126e-02, 2.862e-01) * s0_0_1;
	r1 += V4(9.912e-02, 7.915e-01, -4.301e-02, -6.744e-02) * s0_0_1;
	r0 += V4(-4.652e-03, 2.292e-02, 1.960e-02, 8.964e-02) * s0_0_2;
	r1 += V4(-1.978e-01, 5.250e-03, 3.835e-02, 6.999e-02) * s0_0_2;
	r0 += V4(-7.241e-01, 2.145e-01, -9.360e-02, -8.859e-02) * s0_1_0;
	r1 += V4(1.785e-01, -8.805e-02, 2.955e-02, 3.066e-01) * s0_1_0;
	r0 += V4(3.178e-02, 3.957e-01, 1.101e-01, -5.478e-01) * s0_1_1;
	r1 += V4(-7.598e-01, -5.100e-01, -7.027e-01, -7.532e-01) * s0_1_1;
	r0 += V4(8.479e-02, -1.813e-02, -2.454e-02, -1.284e-01) * s0_1_2;
	r1 += V4(1.491e-01, -7.690e-02, 7.167e-01, -9.099e-02) * s0_1_2;
	r0 += V4(-6.834e-02, -2.094e-02, -2.624e-02, 2.125e-02) * s0_2_0;
	r1 += V4(-9.969e-02, 8.846e-03, -1.080e-02, 2.604e-03) * s0_2_0;
	r0 += V4(7.413e-01, 5.799e-03, 3.794e-01, 2.519e-01) * s0_2_1;
	r1 += V4(2.980e-01, -2.924e-02, 2.641e-02, 5.238e-01) * s0_2_1;
	r0 += V4(-8.081e-02, -5.652e-03, 1.040e-02, 6.032e-02) * s0_2_2;
	r1 += V4(1.584e-01, 2.925e-02, -2.875e-02, 1.502e-02) * s0_2_2;
	r0 += V4(3.106e-03, 1.590e-03, 5.137e-03, 8.094e-03);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-9.195e-03, -2.537e-02, -2.788e-02, -1.788e-02);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-1x8-BILINEAR-MPV-NVL-conv1
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
	r0 = D(r0, s0_0_0, 0x021B07FA, 0x011C1904, 0xF45403F7, 0x180B1608);
	r1 = D(r1, s0_0_0, 0xF3F8DE17, 0x189B1BD9, 0xFCECF3FB, 0xFC040406);
	r0 = D(r0, s0_0_1, 0x12B01A24, 0x22C6ED24, 0x20A1F837, 0xF3A41A1B);
	r1 = D(r1, s0_0_1, 0x0881137F, 0xE9F834ED, 0xFF0C130B, 0x0105F223);
	r0 = D(r0, s0_0_2, 0x10C12613, 0x122AF3FE, 0x0AF70A05, 0x12C4331B);
	r1 = D(r1, s0_0_2, 0x0EE0F63D, 0xFC0CF30E, 0xF9F8FD1A, 0x0F37DBF7);
	r0 = D(r0, s0_1_0, 0x1E2C1A00, 0x07F04313, 0x212F29FF, 0xFEF5EAF5);
	r1 = D(r1, s0_1_0, 0x1B142C12, 0xF94EDFED, 0xFE0A1906, 0x15FF1AF8);
	r0 = D(r0, s0_1_1, 0xABBDE237, 0x9115A159, 0xF5EBE455, 0x9D40B9E4);
	r1 = D(r1, s0_1_1, 0xC8C88141, 0x03E60028, 0x11044DF8, 0x31D1E8FC);
	r0 = D(r0, s0_1_2, 0xFA38FBFA, 0x0DDB224A, 0x02F20241, 0xF712CA11);
	r1 = D(r1, s0_1_2, 0x1FEC817F, 0x0B4DF508, 0xF7090D10, 0x0624F802);
	r0 = D(r0, s0_2_0, 0x200C2302, 0x23FE420B, 0x20194801, 0xCD1700F5);
	r1 = D(r1, s0_2_0, 0xFCE71411, 0x4C092BEF, 0xFE01FBFE, 0xF1050300);
	r0 = D(r0, s0_2_1, 0xD3F7E20E, 0x32FFEC03, 0x37E3AF1C, 0x60FC2FEE);
	r1 = D(r1, s0_2_1, 0xFEE9810C, 0xFAE6CC0C, 0xFF02FF03, 0x0EFB0E04);
	r0 = D(r0, s0_2_2, 0x42FEEDFA, 0xEA05E204, 0xF1FDFF04, 0x0BFA2301);
	r1 = D(r1, s0_2_2, 0x03AF8919, 0x0107DD10, 0x0BFBFB02, 0x0505F701);
	r0 = D(r0, s1_0_0, 0xF0FDF604, 0xDBF6E800, 0xE3ECF102, 0xFDF6FBF8);
	r1 = D(r1, s1_0_0, 0x0E090703, 0x2407F5D8, 0xECFEFF06, 0x30F718DB);
	r0 = D(r0, s1_0_1, 0xED0CF8F1, 0xD407EBF0, 0xD3FEE2E2, 0x1000FCEC);
	r1 = D(r1, s1_0_1, 0x360409F1, 0x2D0201E8, 0x050F04F4, 0x633B3ED4);
	r0 = D(r0, s1_0_2, 0xEC08F200, 0xF3FAFE07, 0x0C06FA11, 0x1800FB07);
	r1 = D(r1, s1_0_2, 0x04FE04F7, 0x09F9FFE1, 0x15FE05FC, 0xEBFB07F9);
	r0 = D(r0, s1_1_0, 0x000001F5, 0xDCFA0A03, 0xAE9BC92F, 0xD7EF0A06);
	r1 = D(r1, s1_1_0, 0x0C060809, 0x6B37FF97, 0xFE09170E, 0xE20FF4F7);
	r0 = D(r0, s1_1_1, 0x134665D4, 0x132453F1, 0x2C3742BA, 0x65636393);
	r1 = D(r1, s1_1_1, 0x7F7C4B0D, 0xD4BFC8D0, 0x042732D4, 0x3236C9A8);
	r0 = D(r0, s1_1_2, 0x282F40F9, 0xB9EE0C1C, 0xC7EEF01E, 0xEBF416F7);
	r1 = D(r1, s1_1_2, 0x280E12F0, 0x2004EFE4, 0x0F0011FE, 0xF8022DF8);
	r0 = D(r0, s1_2_0, 0xF9F91BFA, 0xDD221803, 0xCD253901, 0xEBDD1233);
	r1 = D(r1, s1_2_0, 0x0C0004E4, 0x0315D981, 0x0104FF01, 0xF8081609);
	r0 = D(r0, s1_2_1, 0xE2E9FD30, 0xC2968140, 0xDFBF8915, 0xE00181EB);
	r1 = D(r1, s1_2_1, 0x14F30EF7, 0x540A3398, 0x01FD09FB, 0xFB03E7EE);
	r0 = D(r0, s1_2_2, 0xF213D8DE, 0xD7EDD713, 0xDBECE617, 0xF70D0BF7);
	r1 = D(r1, s1_2_2, 0x2A08FE06, 0x2EFE01D4, 0x0303FAFC, 0x03FF09F9);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-4.068e-03, -3.406e-02, -4.419e-02, 3.338e-04);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(5.833e-02, -1.409e-02, -5.228e-01, -7.814e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-1x8-BILINEAR-MPV-NVL-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv1
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
#define l0(x, y) V4(conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv1_pt))
#define l1(x, y) V4(conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv1_pt))
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
	r0 += M4(-1.489e-01, 6.567e-02, 3.157e-02, 4.051e-02, -1.568e-02, -2.252e-02, -3.232e-02, -2.118e-03, 8.827e-02, -6.909e-02, -2.190e-02, -4.012e-02, 3.672e-02, 5.924e-02, -6.292e-02, -1.146e-02) * s0_0_0;
	r0 += M4(-1.333e-01, -3.947e-01, 6.141e-02, 5.421e-03, 2.220e-01, 3.270e-01, -4.135e-02, -2.648e-02, -2.313e-01, -8.857e-03, 6.567e-02, -1.804e-02, 2.036e-01, 1.996e-01, -1.401e-01, -1.218e-01) * s0_0_1;
	r0 += M4(3.598e-03, 2.070e-02, 8.423e-03, 3.094e-02, 1.509e-01, -9.446e-02, 6.323e-02, -3.901e-02, -5.352e-02, 9.625e-02, 4.927e-02, 1.194e-01, -8.327e-02, -5.481e-02, -3.573e-02, -7.984e-02) * s0_0_2;
	r0 += M4(1.161e-01, 1.552e-01, -4.349e-01, 1.705e-02, 8.310e-02, -6.048e-02, 2.328e-01, -1.208e-02, -1.613e-01, -6.604e-02, 1.284e-01, -2.585e-02, -6.222e-02, 7.735e-02, 4.576e-02, 1.223e-01) * s0_1_0;
	r0 += M4(1.145e-01, 1.587e-01, -1.716e-02, -4.014e-01, -7.207e-01, -1.788e-02, -1.428e-01, 7.535e-01, 6.102e-01, -2.187e-01, -2.357e-01, -4.647e-01, -9.077e-02, -7.921e-01, 7.975e-01, 8.802e-02) * s0_1_1;
	r0 += M4(1.220e-02, 1.274e-02, -6.087e-03, -4.098e-03, 1.392e-01, -3.561e-01, 1.694e-01, -4.381e-01, -6.145e-02, 4.765e-01, -7.155e-02, 3.857e-01, -1.681e-01, 1.548e-01, -1.342e-01, 2.881e-01) * s0_1_2;
	r0 += M4(-3.101e-03, -1.752e-02, 1.910e-01, 9.256e-02, 1.204e-01, 2.619e-02, -3.578e-02, -1.333e-01, -1.042e-01, 2.142e-02, -1.214e-01, 3.342e-02, 3.150e-02, 3.976e-02, 3.510e-02, -5.777e-03) * s0_2_0;
	r0 += M4(-2.841e-04, -7.597e-03, 9.593e-02, 1.687e-01, 2.249e-02, 7.326e-02, -1.317e-01, -1.084e-01, -6.235e-02, -8.079e-02, 2.200e-01, 3.886e-02, 1.674e-01, 2.636e-02, 3.948e-02, -4.895e-02) * s0_2_1;
	r0 += M4(-4.991e-03, 2.036e-03, -4.499e-03, 1.310e-02, -1.510e-02, 1.078e-02, -1.305e-02, 1.665e-02, 5.015e-03, -4.922e-02, -2.436e-02, -6.388e-03, -1.254e-02, 9.590e-02, -1.052e-01, 1.134e-02) * s0_2_2;
	r0 += M4(-4.259e-02, 8.771e-02, 6.758e-02, 2.217e-02, 4.674e-03, -4.941e-02, 3.085e-02, -4.030e-02, -6.939e-02, -1.355e-02, -1.462e-02, 7.146e-02, 1.217e-02, 1.850e-05, -3.673e-05, -2.672e-03) * s1_0_0;
	r0 += M4(-2.630e-01, -2.783e-01, 8.639e-02, 7.143e-02, -5.006e-01, 1.072e-01, 9.301e-02, 1.033e-01, -5.243e-02, -1.004e-01, 2.117e-02, -7.160e-02, -2.484e-02, 1.169e-02, -4.928e-03, 3.800e-04) * s1_0_1;
	r0 += M4(6.371e-02, -7.604e-02, 1.758e-03, 5.336e-02, 2.456e-01, -2.535e-01, 1.294e-01, 2.920e-01, 2.056e-02, 1.112e-01, -6.468e-03, 6.151e-02, 5.409e-03, -1.977e-02, 4.969e-03, -2.209e-03) * s1_0_2;
	r0 += M4(-3.136e-01, 5.105e-02, -2.666e-01, 9.692e-02, -5.210e-02, -8.686e-03, -5.284e-02, -2.020e-02, 1.389e+00, -1.015e-01, 4.335e-01, -8.816e-02, 1.860e-01, -3.650e-02, 4.020e-02, 1.275e-02) * s1_1_0;
	r0 += M4(-8.258e-01, -7.911e-01, -7.734e-01, -8.255e-01, 1.458e-01, -1.187e-02, -2.428e-01, 1.715e-01, 1.043e+00, 2.777e+00, 9.257e-02, 6.993e-01, -4.144e-02, 6.650e-02, 4.557e-02, 5.287e-02) * s1_1_1;
	r0 += M4(9.509e-02, -1.919e-01, 1.150e-01, -2.415e-01, 2.085e-01, 1.221e-01, 4.297e-02, -5.472e-01, -5.360e-02, 3.194e-02, 1.110e-03, -1.893e-02, 1.814e-01, 3.138e-01, 9.796e-03, 5.386e-02) * s1_1_2;
	r0 += M4(4.805e-02, -1.639e-02, -6.904e-02, 4.032e-02, 4.660e-03, 4.133e-03, -1.391e-02, -1.724e-02, -5.127e-02, -3.906e-02, 9.087e-01, -6.599e-02, 1.255e-01, -5.759e-02, 3.467e-01, -2.986e-02) * s1_2_0;
	r0 += M4(6.790e-02, 7.116e-02, -2.212e-01, -2.702e-01, -2.986e-02, -1.083e-02, -2.600e-02, -1.344e-02, 1.695e-01, 3.558e-01, 7.847e-01, 1.805e+00, -4.426e-01, 2.072e-01, -7.751e-01, -5.554e-02) * s1_2_1;
	r0 += M4(4.567e-03, 4.059e-02, 5.903e-02, -1.297e-02, -3.870e-02, -3.845e-02, 6.531e-02, 4.209e-02, -5.991e-02, -1.425e-01, -3.625e-02, 1.505e-02, 1.316e-02, -3.505e-01, 1.273e-01, -1.370e-01) * s1_2_2;
	r0 += V4(-1.338e-08, -1.449e-08, -1.441e-08, -1.283e-08);
	r0 = tanh(r0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
