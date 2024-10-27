// CuNNy 6x16 BILINEAR MPV NVL
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


//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-in
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
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
	ivec2 opos = pos * ivec2(2, 2);
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
	V4 r0, r1, r2, r3;
	r0 = V4(0.0); r1 = V4(0.0); r2 = V4(0.0); r3 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(-6.606e-02, 9.811e-02, 1.788e-02, -4.003e+00) * s0_0_0;
	r1 += V4(-1.401e-02, 2.313e-02, 4.907e-01, -4.915e-02) * s0_0_0;
	r2 += V4(-5.059e-01, -9.809e-02, 2.458e-02, -1.075e-01) * s0_0_0;
	r3 += V4(4.713e-02, 6.087e-02, -4.575e-02, -1.316e-02) * s0_0_0;
	r0 += V4(-9.542e-02, -1.790e-01, -1.468e-02, -4.973e-01) * s0_0_1;
	r1 += V4(1.629e-03, -1.831e-01, -7.349e-02, 2.109e-02) * s0_0_1;
	r2 += V4(2.323e-01, -6.637e-02, 1.792e-01, 9.106e-02) * s0_0_1;
	r3 += V4(9.443e-02, -9.729e-02, 4.751e-02, 2.542e-02) * s0_0_1;
	r0 += V4(-6.999e-02, -2.755e+00, -8.196e-03, 1.294e-01) * s0_0_2;
	r1 += V4(5.343e-03, -3.623e-01, -1.660e-02, 5.676e-02) * s0_0_2;
	r2 += V4(2.748e-01, 7.596e-02, 3.783e-02, 9.450e-03) * s0_0_2;
	r3 += V4(5.244e-02, -1.000e-02, -2.326e-02, -1.278e-02) * s0_0_2;
	r0 += V4(-8.599e-02, -4.937e-02, 4.921e-02, 4.239e-02) * s0_1_0;
	r1 += V4(-4.877e-01, -1.180e-02, -2.566e-01, 1.450e-01) * s0_1_0;
	r2 += V4(-4.805e-02, -5.405e+00, 8.803e-02, -1.103e-01) * s0_1_0;
	r3 += V4(8.552e-02, -3.304e-02, -2.132e-01, 5.542e-03) * s0_1_0;
	r0 += V4(-1.668e-02, 9.934e-02, -4.424e-02, 1.407e-01) * s0_1_1;
	r1 += V4(-2.253e-02, 1.797e-01, -1.756e-01, -2.686e-01) * s0_1_1;
	r2 += V4(-2.997e-02, 4.338e-01, -5.858e-01, -6.398e-02) * s0_1_1;
	r3 += V4(1.098e-01, -1.350e-01, 3.612e-01, 3.610e-01) * s0_1_1;
	r0 += V4(-8.166e-02, -5.516e-01, 4.624e-03, -3.950e-02) * s0_1_2;
	r1 += V4(3.763e-03, 3.582e-01, 3.247e-02, -7.389e-02) * s0_1_2;
	r2 += V4(7.885e-02, -6.308e-02, 3.387e-02, 4.064e-01) * s0_1_2;
	r3 += V4(-1.386e-01, -2.939e-01, -1.382e-01, 1.731e-01) * s0_1_2;
	r0 += V4(-4.509e-02, 6.482e-02, 5.293e-01, -2.107e-02) * s0_2_0;
	r1 += V4(6.888e-03, -2.495e-02, -1.727e-01, -9.781e-02) * s0_2_0;
	r2 += V4(-1.351e-02, -1.024e-01, 1.189e-01, -1.277e-01) * s0_2_0;
	r3 += V4(1.692e-01, 3.309e-01, 7.342e-02, -6.142e-03) * s0_2_0;
	r0 += V4(-1.359e-01, 4.780e-02, -5.371e-01, -3.478e-02) * s0_2_1;
	r1 += V4(5.254e-01, 1.860e-02, 1.883e-01, 1.110e-01) * s0_2_1;
	r2 += V4(1.315e-02, -4.245e-01, -3.955e-01, -1.509e-01) * s0_2_1;
	r3 += V4(-9.983e-03, 1.548e-01, -6.159e-02, -2.895e-01) * s0_2_1;
	r0 += V4(-7.408e-02, 1.444e-01, 4.577e-03, 4.770e-02) * s0_2_2;
	r1 += V4(-1.433e-02, 2.290e-03, -1.250e-02, 2.929e-02) * s0_2_2;
	r2 += V4(-1.174e-03, 9.468e-03, 7.250e-02, 5.215e-02) * s0_2_2;
	r3 += V4(1.569e-01, 1.888e-02, -1.139e-02, -2.455e-01) * s0_2_2;
	r0 += V4(-6.574e-04, 3.224e-02, -1.801e-03, 5.578e-02);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.885e-03, 1.378e-02, -4.953e-04, 1.968e-01);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(6.468e-03, 4.149e-02, 1.783e-02, 1.222e-02);
	r2 = max(r2, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r2));
	r3 += V4(-2.169e-01, 2.814e-02, 6.189e-02, 8.981e-03);
	r3 = max(r3, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r3));
}

//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-conv1
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * in_pt;
			r = in_gather(p, 0);
			g = in_gather(p, 1);
			b = in_gather(p, 2);
			a = in_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x1217FEED, 0xFDFD12FA, 0xDC00F812, 0x0315D8F6);
	r1 = D(r1, s0_0_0, 0xF70EDA04, 0xFEFAD501, 0xEB06A609, 0xF411E6F1);
	r2 = D(r2, s0_0_0, 0xF2F0F3F5, 0xFEE816DE, 0x03F9E6FF, 0x072AE701);
	r3 = D(r3, s0_0_0, 0xEAE8FE0F, 0xF60A130A, 0x0D81F6ED, 0x22070CFC);
	r0 = D(r0, s0_0_1, 0x16240BEE, 0x1E292509, 0x052C11E6, 0x09761EFE);
	r1 = D(r1, s0_0_1, 0xE7C5D9F7, 0xF432FD08, 0xFA813514, 0x051BEAF6);
	r2 = D(r2, s0_0_1, 0x1B0406FA, 0xFD021BE6, 0xEE3F16FD, 0xF462F8EC);
	r3 = D(r3, s0_0_1, 0x0334EFF9, 0xFD1D0816, 0x0B81F201, 0xFB0CF2FC);
	r0 = D(r0, s0_0_2, 0x150E1411, 0xE9491C1C, 0xFF000A08, 0x20440507);
	r1 = D(r1, s0_0_2, 0x0281F1EF, 0xF8ED0207, 0xFAE2F209, 0x0D81230D);
	r2 = D(r2, s0_0_2, 0xFEFFF0F3, 0xFA1B0810, 0x0300FD13, 0x0101FFF8);
	r3 = D(r3, s0_0_2, 0x1A06FF09, 0xE5D807FF, 0xD0D4ECF4, 0x11200601);
	r0 = D(r0, s0_1_0, 0x19F836F5, 0x03FF2209, 0xFE001B18, 0x1CFC0007);
	r1 = D(r1, s0_1_0, 0x260E0EF6, 0x1D0A1406, 0xD0228FFB, 0xF802B6E7);
	r2 = D(r2, s0_1_0, 0x00043CFB, 0xEF0B130D, 0x170F3A05, 0xEFE57009);
	r3 = D(r3, s0_1_0, 0xF408DAF3, 0xF20F38FA, 0xFEB4A208, 0x12EF0FED);
	r0 = D(r0, s0_1_1, 0x24E4010A, 0xCCE3DAEA, 0x0E03E3F1, 0x0C2B35FC);
	r1 = D(r1, s0_1_1, 0x2702E400, 0xE0DBF7F6, 0x007FFD0F, 0x3F1B40ED);
	r2 = D(r2, s0_1_1, 0x000F0A01, 0xF2F4090F, 0x0942E5F2, 0x11A129EF);
	r3 = D(r3, s0_1_1, 0xDC4A1B19, 0x03DF140B, 0xF4A40204, 0xF0FD1BFD);
	r0 = D(r0, s0_1_2, 0x261C14F8, 0xD4E7FBEF, 0x3D130211, 0x0C21EBFF);
	r1 = D(r1, s0_1_2, 0x52ADF2FB, 0xF1D21108, 0x2E4CCF15, 0x00FEFDFA);
	r2 = D(r2, s0_1_2, 0x1B000EFB, 0xE221FE14, 0xE91D0CF9, 0xC2070B00);
	r3 = D(r3, s0_1_2, 0x0616E003, 0x0DCFFF03, 0x150A27EB, 0x013314F1);
	r0 = D(r0, s0_2_0, 0x09FD6904, 0xE1FEDB05, 0x0C0B1403, 0xED041D0E);
	r1 = D(r1, s0_2_0, 0x4315870C, 0xEDF5EDF0, 0x171F9311, 0xF5FD05E6);
	r2 = D(r2, s0_2_0, 0xE4011A02, 0xFD0817F6, 0xFE051400, 0x300307F5);
	r3 = D(r3, s0_2_0, 0x14FF4606, 0x12FBF2FE, 0xE11BBFE7, 0x05070900);
	r0 = D(r0, s0_2_1, 0x53052F0D, 0x0FFC0DF5, 0x670019F2, 0xF30908FA);
	r1 = D(r1, s0_2_1, 0x01143215, 0x3DDF1009, 0xA1222209, 0x0FFC2A0B);
	r2 = D(r2, s0_2_1, 0x3B06FEF8, 0xE21C4E00, 0x40020403, 0xE3E006E5);
	r3 = D(r3, s0_2_1, 0x32F8F9FF, 0xE5F401F0, 0x6BFD07F1, 0x1B060205);
	r0 = D(r0, s0_2_2, 0x4C0FEDF3, 0xAF03FC18, 0x3000EFF1, 0x09101C01);
	r1 = D(r1, s0_2_2, 0x5D05F5ED, 0x29EC0DE5, 0x7DF0BBF6, 0xE50219E7);
	r2 = D(r2, s0_2_2, 0x0E01F00A, 0x310AFB11, 0x4BF50103, 0x8FF3FD07);
	r3 = D(r3, s0_2_2, 0x2CFF0CF9, 0xAB07F801, 0x7F16F60D, 0xD80BE6F9);
	r0 = D(r0, s1_0_0, 0x1B07FE09, 0xE3FCFB03, 0x080D16E6, 0xF814EEFD);
	r1 = D(r1, s1_0_0, 0x021B0424, 0xE7E9041A, 0x1B0B1D15, 0x38010F22);
	r2 = D(r2, s1_0_0, 0x0001FDF9, 0x00FC0CF6, 0xFB070101, 0x18FC0115);
	r3 = D(r3, s1_0_0, 0x17F11D2B, 0xF8FE0AF6, 0x090D0513, 0x0609F408);
	r0 = D(r0, s1_0_1, 0x0501E809, 0xE709F10A, 0x1508FA0D, 0xD9E9F9DE);
	r1 = D(r1, s1_0_1, 0x0B03FDE2, 0xF312080F, 0x0516F7EA, 0xF9122104);
	r2 = D(r2, s1_0_1, 0xFD0BF7F6, 0xE10BF6ED, 0xFD0C0903, 0x11FC03EC);
	r3 = D(r3, s1_0_1, 0x0BF8EDFF, 0xE01508F9, 0x02E903E3, 0x19ED0807);
	r0 = D(r0, s1_0_2, 0xE5EA0319, 0xF917121A, 0xE60EFBFD, 0xF1E1FAB2);
	r1 = D(r1, s1_0_2, 0x19FC068A, 0x10FFFD0E, 0x05EE0F16, 0x1A81C3E1);
	r2 = D(r2, s1_0_2, 0x19080210, 0x06F403F5, 0x04EFFD0C, 0xCCFBF8FA);
	r3 = D(r3, s1_0_2, 0xCFEAF2F9, 0x060B030E, 0xF5FF0BD4, 0xF415FE26);
	r0 = D(r0, s1_1_0, 0x2A07AD27, 0x1FFEDA0E, 0x0D0FE300, 0xF601B4F7);
	r1 = D(r1, s1_1_0, 0x0D26F610, 0x15F72112, 0xF0F217EA, 0x0DE12426);
	r2 = D(r2, s1_1_0, 0x0B05EE00, 0x1B042106, 0x0B0C1001, 0xCD0202A9);
	r3 = D(r3, s1_1_0, 0x090335FA, 0xED18F400, 0xE607F8FC, 0x0E01F304);
	r0 = D(r0, s1_1_1, 0x2E1B30F3, 0x0FF1DFDD, 0xD32B0B0A, 0x34FC0F19);
	r1 = D(r1, s1_1_1, 0xEA38D6BC, 0x0351F316, 0xEC0EF517, 0xD23235F7);
	r2 = D(r2, s1_1_1, 0x0FF7E800, 0x3D00ED06, 0x622709FB, 0xF9FA1E60);
	r3 = D(r3, s1_1_1, 0x001FF432, 0x67FE26FE, 0x1A810FE3, 0x1B1F2F1E);
	r0 = D(r0, s1_1_2, 0xEAFBEE15, 0x1466010B, 0x13110000, 0x08B30E17);
	r1 = D(r1, s1_1_2, 0xDE8EFBB2, 0xF444F8FE, 0x08350BB5, 0x2881CDD6);
	r2 = D(r2, s1_1_2, 0xE309FE2C, 0xCEEBFE0B, 0x0000EFF7, 0x1DDB040E);
	r3 = D(r3, s1_1_2, 0x021EF429, 0xE7DC0CA4, 0x0EFC0881, 0xE7160561);
	r0 = D(r0, s1_2_0, 0xF4E14BF0, 0x0802E8FD, 0x13060301, 0x0EFED405);
	r1 = D(r1, s1_2_0, 0x10FC17FE, 0xFCEA140B, 0x140F8113, 0x1CE9D70A);
	r2 = D(r2, s1_2_0, 0xFC022100, 0xC90B1DEA, 0xC7001A10, 0x25F0CFF6);
	r3 = D(r3, s1_2_0, 0xF1141FFE, 0x06F91DF4, 0xFD0B8112, 0xF50302FB);
	r0 = D(r0, s1_2_1, 0xFF091315, 0x0105DCFC, 0xF70D00F9, 0xF3FBFDE8);
	r1 = D(r1, s1_2_1, 0x05CB2805, 0xF52805F9, 0xFC0FEA10, 0xEA190206);
	r2 = D(r2, s1_2_1, 0xF80115FA, 0xF0FF0DF1, 0xDF200823, 0x030011F3);
	r3 = D(r3, s1_2_1, 0xDA31F6FA, 0xF5D614F2, 0x101D0AD8, 0xEC1143FA);
	r0 = D(r0, s1_2_2, 0xFF01FB01, 0x06120705, 0xF5F6F406, 0xFE020914);
	r1 = D(r1, s1_2_2, 0x1EBC1412, 0x0F131B01, 0xF2DC1215, 0xFFFD24ED);
	r2 = D(r2, s1_2_2, 0x07F60A02, 0x26E40623, 0xFA02F8F8, 0x084700EA);
	r3 = D(r3, s1_2_2, 0x2616F5FA, 0x12F2FEF6, 0x0AF10C18, 0x17EDED0F);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x02110102, 0xFF110103, 0x3710FC01, 0xE70DEF11);
	r1 = D(r1, s0_0_0, 0xF1ECEA19, 0xFF251BFA, 0x00F30104, 0xE0DA2FFA);
	r2 = D(r2, s0_0_0, 0x03F904FD, 0xFDFDF503, 0xEFF5F606, 0x0DF42401);
	r3 = D(r3, s0_0_0, 0xF6030507, 0xFE00FB07, 0x1016F10B, 0xF80F0E0A);
	r0 = D(r0, s0_0_1, 0xD12A2A0C, 0xEB086009, 0x08FE26FD, 0x16280210);
	r1 = D(r1, s0_0_1, 0xD6DDD116, 0x0C0B31FB, 0x050D1508, 0xE80BFC19);
	r2 = D(r2, s0_0_1, 0x060A2700, 0xF1171809, 0xF518E305, 0xFBF8D7FD);
	r3 = D(r3, s0_0_1, 0xD32648FB, 0x08E72D06, 0x99138109, 0xF6F91101);
	r0 = D(r0, s0_0_2, 0x01010407, 0x001E8F09, 0xF912E204, 0x1123CB0B);
	r1 = D(r1, s0_0_2, 0x1DFD8DFF, 0x001633FA, 0x070D3602, 0x21C24781);
	r2 = D(r2, s0_0_2, 0x04080504, 0x1706270E, 0x07F9F7FF, 0x011D28F2);
	r3 = D(r3, s0_0_2, 0xECF8D0F9, 0xFE1CAF02, 0xFE00AFFB, 0xEAF61003);
	r0 = D(r0, s0_1_0, 0x1B0A13F4, 0x0CF81BEA, 0x14F5E80D, 0x0704FB08);
	r1 = D(r1, s0_1_0, 0xDAEFDFE1, 0xE0D90CE7, 0xE4B929F5, 0x13F818F7);
	r2 = D(r2, s0_1_0, 0xF0090001, 0xDE07FC0C, 0xD4FD090B, 0x1EEDECF0);
	r3 = D(r3, s0_1_0, 0xEAE4E8FC, 0x1CF40FFE, 0xF72C0AED, 0x000AFD00);
	r0 = D(r0, s0_1_1, 0x13333EF4, 0xE6F1FB18, 0x06210931, 0x0CFB1FF1);
	r1 = D(r1, s0_1_1, 0x9B343DEB, 0xD210EEEC, 0xE5CE6FFF, 0xF2C904F8);
	r2 = D(r2, s0_1_1, 0x0738FF11, 0xF70ADA02, 0xF11DB300, 0x1B4631E4);
	r3 = D(r3, s0_1_1, 0x28E031E4, 0xE1F40A1F, 0xD0048129, 0x04F60B09);
	r0 = D(r0, s0_1_2, 0xF00462F2, 0xF6F0FCF4, 0x06EF4E08, 0x0AF05BE3);
	r1 = D(r1, s0_1_2, 0x29F0C3D8, 0xD7E9F6EF, 0x16DD44E1, 0xEAB82AFF);
	r2 = D(r2, s0_1_2, 0xFDF12DF8, 0x0B1001EA, 0xFCFB14F1, 0x07F41CF8);
	r3 = D(r3, s0_1_2, 0xFB1C3D0D, 0xF5003917, 0xFF048103, 0x1507FD2A);
	r0 = D(r0, s0_2_0, 0xE02714D8, 0xFA00F907, 0xF5EB00F6, 0x02ED0600);
	r1 = D(r1, s0_2_0, 0x30EC05E9, 0xE1EA1203, 0x1608FA0C, 0xF0FFFCE2);
	r2 = D(r2, s0_2_0, 0xF4F60700, 0xF210EB29, 0x14F609ED, 0xFCEFF436);
	r3 = D(r3, s0_2_0, 0xFADEF900, 0x080BEBEF, 0x070B10F3, 0xFB03040A);
	r0 = D(r0, s0_2_1, 0xED353AE5, 0x0722FE0C, 0x11EC1205, 0x01F3E60E);
	r1 = D(r1, s0_2_1, 0xF6B3F081, 0xF5FDFE08, 0x34220CF3, 0x1E0DF3DC);
	r2 = D(r2, s0_2_1, 0xFDF40CEE, 0x04E40116, 0xF6061309, 0x18D8EF02);
	r3 = D(r3, s0_2_1, 0xFBEDE91C, 0x2907FD07, 0xE42BA381, 0xEF0FF80F);
	r0 = D(r0, s0_2_2, 0xF2033616, 0xFCFD08FD, 0x040D1DFC, 0x031904FC);
	r1 = D(r1, s0_2_2, 0xEF001DE0, 0xF1F7FC22, 0xFF2B2600, 0xD2F6B265);
	r2 = D(r2, s0_2_2, 0x0301180F, 0x0B062EFC, 0x08F11D06, 0xF20D3D04);
	r3 = D(r3, s0_2_2, 0x04F4A6FF, 0xEE1E0EF9, 0x1FE7BD81, 0x06062BEF);
	r0 = D(r0, s1_0_0, 0x1EE0F7CA, 0x230BFDFB, 0x01F507FC, 0x0EDA00FA);
	r1 = D(r1, s1_0_0, 0xEAEDFCFF, 0x1E06FEF9, 0xF6F90D0E, 0x96D7E408);
	r2 = D(r2, s1_0_0, 0x0E1008F7, 0x1507FC07, 0xDAF6FCFE, 0x2DF3EEF3);
	r3 = D(r3, s1_0_0, 0x1F03030A, 0x2902F9FF, 0xA105391C, 0x0EF7F501);
	r0 = D(r0, s1_0_1, 0xF7051AEF, 0x58181A03, 0x17FDFEF0, 0x1743F0EF);
	r1 = D(r1, s1_0_1, 0x051C1AE8, 0x2B2BDC08, 0xDEE6F106, 0x43FFD522);
	r2 = D(r2, s1_0_1, 0x22F5FDF6, 0x1A000003, 0xEF151E06, 0x07FE1DFD);
	r3 = D(r3, s1_0_1, 0xD9FDFB18, 0xF6222108, 0xF50C16F9, 0xCA03030E);
	r0 = D(r0, s1_0_2, 0x00F1FD02, 0x070AF50D, 0xFB0B0202, 0x07E5FA05);
	r1 = D(r1, s1_0_2, 0x07F925FB, 0x0EF3E700, 0x150A0A07, 0x81D78981);
	r2 = D(r2, s1_0_2, 0x00F900F1, 0x21F50EF9, 0x1317EE0A, 0xFEF40D0A);
	r3 = D(r3, s1_0_2, 0xF7060BF2, 0xFB0BFD0A, 0x1303100A, 0x0209FB0A);
	r0 = D(r0, s1_1_0, 0xFBF6FA0E, 0x16E70104, 0xE7F6F601, 0x1D16E300);
	r1 = D(r1, s1_1_0, 0x4603FFFB, 0x2503070D, 0x37E8C2E8, 0x17DDEDF3);
	r2 = D(r2, s1_1_0, 0xF10F02FE, 0x000620F6, 0xDB2F14FB, 0x06F4C608);
	r3 = D(r3, s1_1_0, 0x2306E208, 0x2F0D01FB, 0x01F0E6F5, 0xECEF0306);
	r0 = D(r0, s1_1_1, 0x02F6D90C, 0x09F4FF08, 0xFD48F005, 0xDFFC0909);
	r1 = D(r1, s1_1_1, 0xAAF8130E, 0x29DDE509, 0xF8DBF203, 0x2A6B1127);
	r2 = D(r2, s1_1_1, 0xECD5F9E4, 0xF0E522F4, 0x33B62B01, 0x1511AB11);
	r3 = D(r3, s1_1_1, 0x20FB03F9, 0xF2C80704, 0xFCEB10FB, 0xD5EF0D0B);
	r0 = D(r0, s1_1_2, 0x283BE10D, 0x01F7FCF9, 0x06F60B06, 0x011005F7);
	r1 = D(r1, s1_1_2, 0xDBEFF615, 0x08E202EC, 0xD3020C01, 0xDDDBD809);
	r2 = D(r2, s1_1_2, 0xF714FFE9, 0x04080415, 0x010B06FC, 0xF9DFF4F2);
	r3 = D(r3, s1_1_2, 0xFE0809FC, 0xE2C70409, 0x0FFDEBF3, 0x2D2D0A10);
	r0 = D(r0, s1_2_0, 0x0FEDEDFF, 0x07040CF6, 0x04DD07FB, 0x0A0402FF);
	r1 = D(r1, s1_2_0, 0xF5F0FA08, 0x0D1006F7, 0xE5F8E70E, 0xF4DE06F7);
	r2 = D(r2, s1_2_0, 0x040404F0, 0x09E5F3FC, 0xE504E2FE, 0xD0113B01);
	r3 = D(r3, s1_2_0, 0xE9FEFB05, 0x051C0FFF, 0x20FF07F9, 0x06F306F9);
	r0 = D(r0, s1_2_1, 0xF4FEF2E7, 0xFB160505, 0xF3F5ED08, 0xF6DCFE0B);
	r1 = D(r1, s1_2_1, 0x08EDF6F5, 0x04FB0604, 0xF2F0F5F1, 0x0D3CE10D);
	r2 = D(r2, s1_2_1, 0xEBFEFFF8, 0xFC170000, 0x05F10A06, 0x2C2CDBFC);
	r3 = D(r3, s1_2_1, 0x0700E1FB, 0xF4ED080B, 0xE9FDFFFF, 0xFC11FE02);
	r0 = D(r0, s1_2_2, 0x06E2F7F1, 0x05F20D02, 0x01F202FC, 0x0405F803);
	r1 = D(r1, s1_2_2, 0x071A0A0D, 0xFF0704F9, 0x1438FF0C, 0x02FF1CE8);
	r2 = D(r2, s1_2_2, 0xFF0D01F1, 0xFBFAF504, 0x08FDE9FC, 0x00FE0EFE);
	r3 = D(r3, s1_2_2, 0x09E9F3F6, 0xFD1213F0, 0x020BFA15, 0xFDFAFDF3);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-4.979e-02, -2.060e-02, 4.903e-02, 5.930e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(3.085e-02, 1.420e-02, -2.704e-02, -5.474e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(3.408e-01, 2.644e-02, 1.427e-02, -1.287e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.652e-02, -8.459e-03, 4.579e-02, -2.837e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-conv2
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv1
//!BIND LUMA
//!SAVE conv2
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv1_pt;
			r = conv1_gather(p, 0);
			g = conv1_gather(p, 1);
			b = conv1_gather(p, 2);
			a = conv1_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0C04F8FD, 0xFFFCFC06, 0xEE0920F8, 0xF40909FF);
	r1 = D(r1, s0_0_0, 0xF805FFF0, 0x040D1404, 0xF9F80703, 0x120801F2);
	r2 = D(r2, s0_0_0, 0xFAF5E003, 0x06F0DE26, 0x11260AEC, 0xE90D12F7);
	r3 = D(r3, s0_0_0, 0xF1FF0D14, 0xF50A1B02, 0x0704F3FB, 0xFF0006F4);
	r0 = D(r0, s0_0_1, 0xEE1AEB07, 0xFB07F00C, 0xF6FD0F0F, 0x0A03F110);
	r1 = D(r1, s0_0_1, 0xFE020CEE, 0x05EB0609, 0xFF0C02F9, 0xF8100BF9);
	r2 = D(r2, s0_0_1, 0x0D040DF3, 0xE6FAFF00, 0xFC0E19DE, 0xFE102222);
	r3 = D(r3, s0_0_1, 0xEAF809DA, 0x0304041C, 0x04F905FE, 0x00190814);
	r0 = D(r0, s0_0_2, 0xDBEE1816, 0x0812FDE1, 0xF1FC0A06, 0xFCFFF309);
	r1 = D(r1, s0_0_2, 0xFF1701E2, 0x0113FB10, 0x0607F8F9, 0x071EE801);
	r2 = D(r2, s0_0_2, 0x02FEEDF7, 0xE9FF0CF7, 0xE925ED23, 0xF9FA171D);
	r3 = D(r3, s0_0_2, 0x0DE50504, 0x0118060B, 0xEF0403F8, 0xE9FC08F2);
	r0 = D(r0, s0_1_0, 0x0709E502, 0x060D040C, 0xFFCA0325, 0xF7F4020C);
	r1 = D(r1, s0_1_0, 0xF902EE07, 0x09150EFC, 0xFC0D0EF0, 0xD9FB11F0);
	r2 = D(r2, s0_1_0, 0x160817F8, 0x26FDF6FF, 0xEAFFC614, 0x0300050A);
	r3 = D(r3, s0_1_0, 0xFCFF1B10, 0xFCF7FD17, 0x00EE161B, 0x0400160E);
	r0 = D(r0, s0_1_1, 0xF4F0D3F7, 0xD2FAFEFB, 0x0407161F, 0x1D15E40F);
	r1 = D(r1, s0_1_1, 0x13F63819, 0x19EFF905, 0x13FA1411, 0xBAE708E5);
	r2 = D(r2, s0_1_1, 0xE625EE07, 0xDB0F1C41, 0xB2C7E5FF, 0x22FB31FC);
	r3 = D(r3, s0_1_1, 0x31EC1012, 0xE6FE0E25, 0x15031907, 0x05F51003);
	r0 = D(r0, s0_1_2, 0xCB17161C, 0xEEFB00FF, 0xFD07EC25, 0x1408FCFD);
	r1 = D(r1, s0_1_2, 0x0E0EECFF, 0x01F10B0C, 0xFC2AFFFD, 0x1EEBE400);
	r2 = D(r2, s0_1_2, 0xEFFA08FD, 0xF018020C, 0x0ED518FC, 0xD90B1705);
	r3 = D(r3, s0_1_2, 0x2011F924, 0x0BE5091B, 0xFD0607F5, 0x07B9090A);
	r0 = D(r0, s0_2_0, 0xE9F0F502, 0x020AF8FC, 0x0101F522, 0x06111502);
	r1 = D(r1, s0_2_0, 0x0CFFF9FE, 0xFE1F21DB, 0x09EEFFF9, 0x1A05D1F1);
	r2 = D(r2, s0_2_0, 0x06F00A0B, 0x0B0E02F4, 0x01F402F9, 0x06FC0304);
	r3 = D(r3, s0_2_0, 0xBBD11144, 0xFE090B0B, 0x121721F0, 0x0603FAFF);
	r0 = D(r0, s0_2_1, 0xD0F50A03, 0xEE0F05FE, 0x3516DE27, 0x01FE09FD);
	r1 = D(r1, s0_2_1, 0x0C01010B, 0x27ECEF14, 0x07F5030F, 0xFFB7DA0F);
	r2 = D(r2, s0_2_1, 0xFCFC0F05, 0x16F7E62B, 0x120C24EE, 0x16FF190D);
	r3 = D(r3, s0_2_1, 0xEEA4140A, 0x0C0D0803, 0x2C113215, 0xF1FB16FD);
	r0 = D(r0, s0_2_2, 0x00FC2A10, 0x0BF005F9, 0x0430DAE7, 0xED210AF5);
	r1 = D(r1, s0_2_2, 0x0A16FDFC, 0x04E4F209, 0xFC180DFE, 0x05F50912);
	r2 = D(r2, s0_2_2, 0xFCF30908, 0x0D1903EB, 0x0FE30614, 0x0BD91500);
	r3 = D(r3, s0_2_2, 0x4E86B861, 0x07FDEB14, 0x0C20FFF9, 0x020006FE);
	r0 = D(r0, s1_0_0, 0xC802FE0F, 0x081207F5, 0x0A0AF0EF, 0x0202ECF5);
	r1 = D(r1, s1_0_0, 0xFB0201FC, 0x07FE1810, 0xFA0604F8, 0x2A1001F0);
	r2 = D(r2, s1_0_0, 0x0312280D, 0xF9EB0808, 0x2832F410, 0x130EEF0B);
	r3 = D(r3, s1_0_0, 0x24EAFF0B, 0x1805FCF4, 0x02F90FFA, 0xF50403F4);
	r0 = D(r0, s1_0_1, 0x0BE4FFF3, 0xF70FFDE7, 0xFE1DE2F1, 0x070A1605);
	r1 = D(r1, s1_0_1, 0x11EFEBF7, 0x11F7E703, 0x0C0CF4F9, 0xD710C513);
	r2 = D(r2, s1_0_1, 0xFEF4F61D, 0x02CD1807, 0x8FBBFE3C, 0xEEFF0800);
	r3 = D(r3, s1_0_1, 0xED20E300, 0x14FBF5FA, 0xFDFB060A, 0x19FFDF06);
	r0 = D(r0, s1_0_2, 0x07FACB2B, 0xF1F6E6FF, 0x04E5F32B, 0xFCF22A16);
	r1 = D(r1, s1_0_2, 0xF305E2FC, 0xFC2623F5, 0xFA0104ED, 0x0D0D2905);
	r2 = D(r2, s1_0_2, 0xFE090C01, 0xF2FA0C0E, 0x1A02CD81, 0x0F12C90E);
	r3 = D(r3, s1_0_2, 0x1F100E0B, 0x0507F509, 0x02F2F015, 0x02F8FFFC);
	r0 = D(r0, s1_1_0, 0xD5F4180E, 0x1CF20112, 0xFD2816E9, 0x0C170DFF);
	r1 = D(r1, s1_1_0, 0x09051104, 0x1A063218, 0x1D0BFFF8, 0x2BE8F90B);
	r2 = D(r2, s1_1_0, 0xF6E9D41C, 0x06ED09EE, 0xA5F8F7F0, 0xEEF2F727);
	r3 = D(r3, s1_1_0, 0x62F70342, 0x1D0BF80B, 0x04110F18, 0x3507FE07);
	r0 = D(r0, s1_1_1, 0x02E524DE, 0x14090F1D, 0x311F0AC5, 0x2D0909E9);
	r1 = D(r1, s1_1_1, 0x29061715, 0x0801C918, 0xE009F9F4, 0xF3F2CC21);
	r2 = D(r2, s1_1_1, 0xF8FAF305, 0xF2BB200F, 0x48017DD5, 0x16F1D8E5);
	r3 = D(r3, s1_1_1, 0x2081FDDB, 0x4100DB02, 0x370CEC08, 0x0E040101);
	r0 = D(r0, s1_1_2, 0x0B0DD610, 0x02F4F4E7, 0x1018FFC9, 0xFBFA0BE3);
	r1 = D(r1, s1_1_2, 0xF60A060B, 0x012838FA, 0xF50617EF, 0xDE11152D);
	r2 = D(r2, s1_1_2, 0xFAF81503, 0xFFFDE843, 0xE3DB3074, 0xD4E6D0E6);
	r3 = D(r3, s1_1_2, 0x1F95F83A, 0x100B08F3, 0xF7F7F3DA, 0xDF010430);
	r0 = D(r0, s1_2_0, 0x9F05E304, 0x08FBFA07, 0x81EF0DEA, 0x5A0509F6);
	r1 = D(r1, s1_2_0, 0x7F00FC04, 0x7F0506EB, 0x7F060301, 0x7F12FF03);
	r2 = D(r2, s1_2_0, 0x8F001009, 0x7FF1FD03, 0x3708F5F9, 0x1916EF0F);
	r3 = D(r3, s1_2_0, 0x6710F31A, 0x7F0A0301, 0x78FD04EC, 0x9DFDF6F5);
	r0 = D(r0, s1_2_1, 0x1AEE0608, 0x0EFF14FD, 0xBBF905F4, 0xD705F2FD);
	r1 = D(r1, s1_2_1, 0xDAFA1BFA, 0x02F413F5, 0x0E0BFAF7, 0x13025908);
	r2 = D(r2, s1_2_1, 0x1407130B, 0xFEE12C0F, 0x6B03D910, 0xDEFCD50F);
	r3 = D(r3, s1_2_1, 0x81188181, 0x07000EFA, 0xD0F5F4F3, 0xBCFCFE0A);
	r0 = D(r0, s1_2_2, 0xF211FB0C, 0x06F0EE11, 0xFB01F6FA, 0x1D06F50F);
	r1 = D(r1, s1_2_2, 0x1CFBF302, 0x101928F9, 0x0E01FD0A, 0x2025DEF9);
	r2 = D(r2, s1_2_2, 0xFCF2090C, 0x13F8DE2D, 0xFDDBF708, 0x33F6DA07);
	r3 = D(r3, s1_2_2, 0xBDD09081, 0x2D060409, 0x1A03F908, 0x0102020C);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0FDAF105, 0xF610FB0C, 0x2B0E0AFF, 0x0307FBF5);
	r1 = D(r1, s0_0_0, 0x010511FA, 0xDAEB0EF9, 0x03FE0904, 0x00261DFB);
	r2 = D(r2, s0_0_0, 0x00E1FF16, 0xFE01F8FC, 0xF608F8FE, 0x0305F7F0);
	r3 = D(r3, s0_0_0, 0xEC08FDF5, 0x071403E3, 0x0103F204, 0xFFFD0205);
	r0 = D(r0, s0_0_1, 0x0BCA14ED, 0x10163431, 0x0E13020B, 0x00000C18);
	r1 = D(r1, s0_0_1, 0x06042FF3, 0xD4F3D004, 0xF5FBEDF6, 0x042B21FB);
	r2 = D(r2, s0_0_1, 0xECDF19E0, 0x27F91AFD, 0x241EF52F, 0x2FE4CAE9);
	r3 = D(r3, s0_0_1, 0x1020211D, 0x0E0511D9, 0x08091503, 0x051DFAF2);
	r0 = D(r0, s0_0_2, 0xF8E634F7, 0xEDFFF6FB, 0xED080BF0, 0xE60DFE00);
	r1 = D(r1, s0_0_2, 0x111D0009, 0xC616F7FB, 0x01FC0107, 0x34F8FBF8);
	r2 = D(r2, s0_0_2, 0x20FA1414, 0x2A19EC04, 0xE8B10FF8, 0xE5201FF9);
	r3 = D(r3, s0_0_2, 0x1AFA04ED, 0xB90CFDDA, 0xF7FC0EFF, 0x12021708);
	r0 = D(r0, s0_1_0, 0x020106EC, 0xF5FFF8F4, 0x080AF3FA, 0xF5FCFD0D);
	r1 = D(r1, s0_1_0, 0x040013FD, 0xD5E1F80A, 0x050302F5, 0x19F4E4FE);
	r2 = D(r2, s0_1_0, 0x0AFC0E15, 0xE8F20002, 0xF50B10F4, 0xF808E3F9);
	r3 = D(r3, s0_1_0, 0x15210DF9, 0xFA0209B9, 0xFCF3FDEC, 0xFAF4F4EF);
	r0 = D(r0, s0_1_1, 0xEA07F833, 0xFE070A02, 0x03FEDFDB, 0x05F2E9DD);
	r1 = D(r1, s0_1_1, 0xFAFEF7E6, 0xC6C9C01D, 0x09FF083B, 0x4E3245FF);
	r2 = D(r2, s0_1_1, 0x01E71BEB, 0xFF1303FE, 0x0DDCCC01, 0xE517ECD9);
	r3 = D(r3, s0_1_1, 0x07081033, 0x24CC0381, 0xEFC0ADDF, 0x0D0117E1);
	r0 = D(r0, s0_1_2, 0x1DDE0708, 0x0FEF01FE, 0x0EFF13F7, 0xE90500FE);
	r1 = D(r1, s0_1_2, 0x07F60B16, 0xE61D09FE, 0x14F001FA, 0x1736FB02);
	r2 = D(r2, s0_1_2, 0x03092709, 0x3836ED01, 0xE92405C6, 0x97D9130D);
	r3 = D(r3, s0_1_2, 0x2DBD0F0B, 0x311BFBB5, 0x04FEF3FD, 0x0B45242D);
	r0 = D(r0, s0_2_0, 0x0E12F903, 0xFAFCFCFA, 0xF4110511, 0xF809FDF3);
	r1 = D(r1, s0_2_0, 0xFCFAFD0B, 0xF0EF1414, 0x00FDFAFF, 0xE9E4E2FC);
	r2 = D(r2, s0_2_0, 0x02F2FB05, 0x0A0014F9, 0x101518F3, 0x06FF0A13);
	r3 = D(r3, s0_2_0, 0x0519EBE2, 0x010C08DF, 0xF3110811, 0x00FC0D06);
	r0 = D(r0, s0_2_1, 0x0B07F5F9, 0x0104EEEF, 0xF2EA0D25, 0x08F8161D);
	r1 = D(r1, s0_2_1, 0xFFFFF5FE, 0xEAF608F5, 0x05FFF1F8, 0x270FE5F9);
	r2 = D(r2, s0_2_1, 0xF1FEF7F0, 0x0CFF1004, 0x03FA121B, 0x0908F810);
	r3 = D(r3, s0_2_1, 0x65C8071A, 0x0505FCBF, 0xF3F6F91C, 0xFB0605EC);
	r0 = D(r0, s0_2_2, 0x040CF3EC, 0x04050107, 0x051F160D, 0xEE06FCFD);
	r1 = D(r1, s0_2_2, 0xFC09F80A, 0xECF30AE0, 0xFF0EFAF6, 0x071EF512);
	r2 = D(r2, s0_2_2, 0x09F4FEFF, 0xFEFCF80C, 0xF1E0FC09, 0xEEF3FC0A);
	r3 = D(r3, s0_2_2, 0x0A810BE7, 0xF60A00E8, 0xF9E1FF05, 0xF4FA0611);
	r0 = D(r0, s1_0_0, 0xF0E53718, 0x200E05F6, 0x0C1100FB, 0xFEFC0905);
	r1 = D(r1, s1_0_0, 0x04100401, 0x1607E909, 0x03F9FF02, 0x0908D1E0);
	r2 = D(r2, s1_0_0, 0xF3DD0F11, 0x09EA210C, 0x0D43221E, 0x01061D1D);
	r3 = D(r3, s1_0_0, 0x0EF7ED0B, 0x0EFFFCFB, 0x05030AF9, 0x0B04F80A);
	r0 = D(r0, s1_0_1, 0xF1F72327, 0x1904F608, 0x01F2FFF8, 0x13FF170C);
	r1 = D(r1, s1_0_1, 0x0E12DFFA, 0x031C0BF2, 0xFF13F912, 0xDEDF00E0);
	r2 = D(r2, s1_0_1, 0x1A1CF814, 0xF5FE0F01, 0x0AA11C0C, 0xFB08090A);
	r3 = D(r3, s1_0_1, 0x0AFC0204, 0x1210160E, 0x140BF30A, 0xED01E50B);
	r0 = D(r0, s1_0_2, 0x07F21408, 0xF7171528, 0xF80D0607, 0x04F30EEC);
	r1 = D(r1, s1_0_2, 0x01000010, 0x09FAF8F0, 0x07EAFEEF, 0x00E8D91B);
	r2 = D(r2, s1_0_2, 0x04FCECE5, 0xF7E302F4, 0xFEFF1E22, 0x05F108F0);
	r3 = D(r3, s1_0_2, 0x0EE20F32, 0x160200EF, 0xFA0602F9, 0xFE070E06);
	r0 = D(r0, s1_1_0, 0xCFCE1D24, 0xFDF90303, 0x0FFFDCEC, 0x23F60004);
	r1 = D(r1, s1_1_0, 0xF907FC01, 0x0310C2D5, 0x0D080A0A, 0xE72E03F5);
	r2 = D(r2, s1_1_0, 0xE9160C19, 0xF7F10F02, 0xECE7F818, 0xEDE6F419);
	r3 = D(r3, s1_1_0, 0x1EEEF4F4, 0x150FF80C, 0xED06E6F4, 0xFF09FA10);
	r0 = D(r0, s1_1_1, 0x050A27DC, 0x0E1C05EE, 0xDFB1D0EF, 0xE000F3F9);
	r1 = D(r1, s1_1_1, 0x0BD6E2E1, 0x11FD120C, 0x19FB05FF, 0x06EF1428);
	r2 = D(r2, s1_1_1, 0xF1083F14, 0x110A09ED, 0x2706FDC8, 0x9AF00F21);
	r3 = D(r3, s1_1_1, 0x27AF0120, 0x10EFF7F2, 0xE11302F3, 0xD323F40C);
	r0 = D(r0, s1_1_2, 0xFCC5E8FC, 0x05F2FB1F, 0x0AF1E4FF, 0xFE161208);
	r1 = D(r1, s1_1_2, 0x0D100800, 0x0C09FC1C, 0xF900F0F8, 0x04CFE5C4);
	r2 = D(r2, s1_1_2, 0xFAF40F0A, 0x0FE8D7EA, 0xFA3522DD, 0xED0E11F9);
	r3 = D(r3, s1_1_2, 0xFBE7B2F2, 0x21ED021C, 0x09F30617, 0xFFFD1ADA);
	r0 = D(r0, s1_2_0, 0x08FEFA0E, 0x110709FD, 0xDDF0FCEF, 0x0BFFFDFE);
	r1 = D(r1, s1_2_0, 0x0307F700, 0xF5020808, 0x0F070207, 0x1A163623);
	r2 = D(r2, s1_2_0, 0x1DFB0EFB, 0x06ED03FC, 0xF106DFDA, 0x01F3F305);
	r3 = D(r3, s1_2_0, 0xFDDEC210, 0x11FB0804, 0x060101F6, 0xF4F20009);
	r0 = D(r0, s1_2_1, 0x0DF205F8, 0x000303FE, 0xF5B51621, 0xE4FFFB00);
	r1 = D(r1, s1_2_1, 0xF80CFCF1, 0xF903E9F2, 0x0CFA05FD, 0xF70602C9);
	r2 = D(r2, s1_2_1, 0x16151205, 0xFFD2F317, 0xF1EDC721, 0xDC03E4E5);
	r3 = D(r3, s1_2_1, 0xE63AA6DE, 0xF60607F9, 0x0209090C, 0xFF000C07);
	r0 = D(r0, s1_2_2, 0x15F4E8FE, 0x0613FA11, 0xE281F6DF, 0x0E040912);
	r1 = D(r1, s1_2_2, 0xF90AFBFF, 0x0CD21906, 0x060B03FD, 0xF2E3FBEE);
	r2 = D(r2, s1_2_2, 0x021601FA, 0x05DFF6F3, 0x0AE5E801, 0x0800E32C);
	r3 = D(r3, s1_2_2, 0xC5C98181, 0x080F0109, 0x04FB001B, 0x04F408F5);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(8.713e-02, -9.694e-02, -4.251e-02, -1.376e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-2.424e-02, -7.006e-04, -4.456e-02, -8.390e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-3.262e-02, -6.274e-02, 1.987e-02, 1.627e-01);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-9.357e-02, -9.387e-02, 1.113e-02, 2.520e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-conv3
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv2
//!BIND LUMA
//!SAVE conv3
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv2_pt;
			r = conv2_gather(p, 0);
			g = conv2_gather(p, 1);
			b = conv2_gather(p, 2);
			a = conv2_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0A0D03EE, 0xF70715FE, 0x03FB0404, 0x0EF80AF3);
	r1 = D(r1, s0_0_0, 0xF80305F4, 0x06F20A07, 0xFF0500FA, 0x01E804EB);
	r2 = D(r2, s0_0_0, 0xF5F40714, 0x0817F2FF, 0xF10D101C, 0x04FBF8FE);
	r3 = D(r3, s0_0_0, 0x17030C27, 0xF115FB04, 0x18FFF11E, 0xEDF509E3);
	r0 = D(r0, s0_0_1, 0x0FE4F6C9, 0x2FDAFA03, 0xF6F2F607, 0x308FE7FB);
	r1 = D(r1, s0_0_1, 0xF4FE0404, 0x02EAFC00, 0x070FFB03, 0x02190804);
	r2 = D(r2, s0_0_1, 0x1338F40F, 0xEBFE0403, 0xFC1AF2FB, 0x20FAF5F8);
	r3 = D(r3, s0_0_1, 0xDD28FD10, 0x0CEF04FE, 0xE5130200, 0x01EFFFF0);
	r0 = D(r0, s0_0_2, 0xF4FA0BEE, 0xEE1AEF19, 0x010E0307, 0x0716040C);
	r1 = D(r1, s0_0_2, 0x07FB00FE, 0x0F020401, 0xFC00FE02, 0xFEF302F7);
	r2 = D(r2, s0_0_2, 0xF520FAFF, 0x00FA06FD, 0x11D1ED0A, 0xFAF0FCF6);
	r3 = D(r3, s0_0_2, 0x07F102EE, 0xFC0300FE, 0xF8FFFE03, 0x0AEE0209);
	r0 = D(r0, s0_1_0, 0x070C09E9, 0xF22105F3, 0x04F71707, 0x182A13C5);
	r1 = D(r1, s0_1_0, 0x09F106F9, 0x18050201, 0x04080401, 0xE7E8FF29);
	r2 = D(r2, s0_1_0, 0x1802D703, 0xFDF0F9FC, 0x00F7FD16, 0x0DFE1419);
	r3 = D(r3, s0_1_0, 0x0507FB12, 0xF7EEF6FA, 0xE803FA26, 0x17090204);
	r0 = D(r0, s0_1_1, 0x0513EE20, 0xEE02D719, 0x2FFDF301, 0x08AB28F0);
	r1 = D(r1, s0_1_1, 0xFEE60B00, 0x0A02D4F2, 0xE6FFF60A, 0xAF2BFBF1);
	r2 = D(r2, s0_1_1, 0x06F2E6F2, 0xF9040CE4, 0xF2320119, 0xFBE501F7);
	r3 = D(r3, s0_1_1, 0xFD1B1ECB, 0x0FF5F910, 0xF4F4F3F3, 0xEEE4FE02);
	r0 = D(r0, s0_1_2, 0xED20000C, 0xFDF109F9, 0x09F00700, 0xD914BB06);
	r1 = D(r1, s0_1_2, 0x04FD0313, 0x081D0407, 0x080107FE, 0x17EA02F4);
	r2 = D(r2, s0_1_2, 0xECF5FE11, 0xFEF6F8E8, 0x10FC32EF, 0xFA0D0317);
	r3 = D(r3, s0_1_2, 0x0FCC06CE, 0x04010111, 0x1003FCFC, 0x1707FD1A);
	r0 = D(r0, s0_2_0, 0xFD04FF03, 0x050EEBED, 0xF5FDF2FC, 0x08FAE619);
	r1 = D(r1, s0_2_0, 0x11F5F8FD, 0x09FB0805, 0x0BFDFB04, 0x14F91C01);
	r2 = D(r2, s0_2_0, 0xFAF10710, 0xF4011BF9, 0xF4FE0806, 0x0001F812);
	r3 = D(r3, s0_2_0, 0x18FDF815, 0xF6FE07F0, 0x0C12EE06, 0xF3FC15F5);
	r0 = D(r0, s0_2_1, 0xF20F0D01, 0x04E0D4FA, 0xDCF0E402, 0xCD0CFF09);
	r1 = D(r1, s0_2_1, 0x1B071C09, 0x0D01EAF3, 0x060710FF, 0x2A214301);
	r2 = D(r2, s0_2_1, 0x1106281F, 0x1311FB03, 0x181617E6, 0x0C180314);
	r3 = D(r3, s0_2_1, 0xE3FCF4C0, 0x040DFC00, 0xF0FEEB0F, 0xFEFEF70D);
	r0 = D(r0, s0_2_2, 0x1B15FC0F, 0x18FBF5E5, 0xFFF7EF04, 0xEC232503);
	r1 = D(r1, s0_2_2, 0x1B0C02F9, 0xF7FD110C, 0x07020100, 0x1A0C02EC);
	r2 = D(r2, s0_2_2, 0xF3FE1D0E, 0xF6F1F5FA, 0xCFE68205, 0x00F821F8);
	r3 = D(r3, s0_2_2, 0xF00FC5C0, 0x10FCFDF7, 0xF902FBFF, 0x010A03FD);
	r0 = D(r0, s1_0_0, 0xFF02FCD2, 0x1E3D44F8, 0xF7F0FC0B, 0xC5EBF6F2);
	r1 = D(r1, s1_0_0, 0xF6F5FAF8, 0xEFFEFF03, 0xFBF5FEFD, 0xFD05F5FD);
	r2 = D(r2, s1_0_0, 0xFCEEECFD, 0xFB06FF08, 0xFF0D1C05, 0x06EDFC0C);
	r3 = D(r3, s1_0_0, 0xF8F71722, 0x0C09E9E7, 0x20FDFA21, 0xDCEBFFE4);
	r0 = D(r0, s1_0_1, 0x38AAF600, 0x27E7B220, 0x00020D05, 0xE5D3BE1A);
	r1 = D(r1, s1_0_1, 0xF2112607, 0x021E03EF, 0xFCF4070D, 0xFB070AFA);
	r2 = D(r2, s1_0_1, 0xE50910FF, 0x08F30E14, 0x18FAD91F, 0x13FE02F9);
	r3 = D(r3, s1_0_1, 0xDCF8FBE3, 0x04F3F400, 0x13F9EF13, 0xD90402F6);
	r0 = D(r0, s1_0_2, 0x06052004, 0xFBEFF9FE, 0xFAFBEBF9, 0x01040513);
	r1 = D(r1, s1_0_2, 0xFF05ECF9, 0x1B070506, 0xFCF20005, 0xFE0110FB);
	r2 = D(r2, s1_0_2, 0xFD03F7F8, 0xF0011A04, 0xFFE01603, 0x04FEFC0B);
	r3 = D(r3, s1_0_2, 0xF90408EE, 0x0908FB0B, 0x07E907FD, 0x010600F9);
	r0 = D(r0, s1_1_0, 0x091A1112, 0xEFED1D1F, 0xFF23F6E5, 0xBADA00D5);
	r1 = D(r1, s1_1_0, 0xF008F817, 0x05FC04FF, 0xFB08F412, 0x05F01C11);
	r2 = D(r2, s1_1_0, 0x09E202FF, 0xF3F5FE0D, 0xF4F800EA, 0x21170701);
	r3 = D(r3, s1_1_0, 0x140D01D9, 0xF9E4142A, 0x1B171BFB, 0x02110C08);
	r0 = D(r0, s1_1_1, 0xEFF40E09, 0xEE3097F8, 0x3816EF0F, 0x86CBF1F4);
	r1 = D(r1, s1_1_1, 0x14FB03E8, 0xFADA1CFE, 0x1545F8F6, 0xC3F107D8);
	r2 = D(r2, s1_1_1, 0x0D0703F6, 0x2D12F7F8, 0x332A4018, 0xDDE304E5);
	r3 = D(r3, s1_1_1, 0xF108F700, 0x030B13F4, 0x290CF617, 0xD5190D0F);
	r0 = D(r0, s1_1_2, 0xF102D80C, 0x21E512F8, 0x030D09FF, 0xF1FA161B);
	r1 = D(r1, s1_1_2, 0xF7120E05, 0xE909F8E8, 0x1304FDFC, 0x000DEBFA);
	r2 = D(r2, s1_1_2, 0x02E9151B, 0xFC05FAF2, 0x23EFF31C, 0x0410FEE4);
	r3 = D(r3, s1_1_2, 0x0AFD0F1F, 0x0BFA02F5, 0x14060E0B, 0xEDDA2214);
	r0 = D(r0, s1_2_0, 0x060CE9F6, 0x03E807E7, 0xF8FEF10A, 0x36290EC3);
	r1 = D(r1, s1_2_0, 0x0E0612FD, 0xFBFCFD0B, 0xFBFDFE0A, 0x091302E6);
	r2 = D(r2, s1_2_0, 0xF6F7EEF9, 0xF208FF08, 0xF0F70C05, 0x080103F3);
	r3 = D(r3, s1_2_0, 0xFA00FEE6, 0x07FE0C23, 0x16F6EADC, 0xF3F70E07);
	r0 = D(r0, s1_2_1, 0x190A06FA, 0x332DFC0F, 0x18FAFF12, 0xDF390C08);
	r1 = D(r1, s1_2_1, 0x04EF1006, 0x1E03FCF6, 0x01FFFFFD, 0xFEF0F90E);
	r2 = D(r2, s1_2_1, 0x03F2DFEF, 0x0601FFF1, 0x0DF4CC8F, 0x06F310E1);
	r3 = D(r3, s1_2_1, 0xCFD90B0E, 0x04F8F2F8, 0x0F17D7EB, 0xF60100F1);
	r0 = D(r0, s1_2_2, 0x060E0DF8, 0x0005EF0A, 0x0B07F8F0, 0xF10B0718);
	r1 = D(r1, s1_2_2, 0x0414FE00, 0xF6F616FB, 0x061001F9, 0x0E180215);
	r2 = D(r2, s1_2_2, 0xF8F00DF5, 0xEB0AFFFD, 0xE7DCBB39, 0xF7E81AF2);
	r3 = D(r3, s1_2_2, 0xFA0F03F0, 0x0E0AFFF6, 0x12EE05E5, 0xE60D0504);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x031DF402, 0xF1E6E6CB, 0xFC040301, 0x0F16F9F3);
	r1 = D(r1, s0_0_0, 0x150605FF, 0xFA0E0302, 0xFD010005, 0x09F9FC09);
	r2 = D(r2, s0_0_0, 0x030FFD17, 0x0D0208F5, 0xDFFFF8E4, 0xF00BF90D);
	r3 = D(r3, s0_0_0, 0xD1F5EAFE, 0x0005FFFF, 0xEE0A0AEB, 0x12160706);
	r0 = D(r0, s0_0_1, 0x2CF0FFFF, 0x0FE70003, 0xFD0BF8FA, 0x10030600);
	r1 = D(r1, s0_0_1, 0xF70AEEF8, 0x0F0DFEF1, 0x00070D00, 0x05010805);
	r2 = D(r2, s0_0_1, 0xEC080F14, 0xEC0216F8, 0x18FAFCF5, 0x0B090007);
	r3 = D(r3, s0_0_1, 0x150BFC0C, 0x07FF08F3, 0xFF07FC06, 0x0A0EFC00);
	r0 = D(r0, s0_0_2, 0xFA0507F9, 0x0D02FE20, 0xFB020003, 0xFF131E00);
	r1 = D(r1, s0_0_2, 0x0CFEFBF9, 0xFA02FFFC, 0x04030503, 0x0902FC01);
	r2 = D(r2, s0_0_2, 0x05FEFA02, 0xF409FAF9, 0x05000BF4, 0x08FD0CF9);
	r3 = D(r3, s0_0_2, 0x070612FB, 0x00FB00FC, 0xFA09180C, 0xFC07F501);
	r0 = D(r0, s0_1_0, 0xDC2FFAEA, 0xFFE21E20, 0xF509FA07, 0xEF0A1907);
	r1 = D(r1, s0_1_0, 0xFC01F708, 0xF6F904E5, 0xF903FD07, 0xE801FBF8);
	r2 = D(r2, s0_1_0, 0x07F00600, 0x04050615, 0xE00013F9, 0xF228F3F6);
	r3 = D(r3, s0_1_0, 0xD7FC1604, 0xF90F0619, 0x2AFE0DED, 0x010BFCEF);
	r0 = D(r0, s0_1_1, 0x1217E7EE, 0xFF1BDFDD, 0x0E0907F5, 0x0015F9D9);
	r1 = D(r1, s0_1_1, 0xF7061AFC, 0x21120F03, 0x09070DEB, 0xE30EEE04);
	r2 = D(r2, s0_1_1, 0x18F12902, 0x0308ECF3, 0x26D7FEE0, 0x06190C0A);
	r3 = D(r3, s0_1_1, 0x2A09ED1B, 0xF20BF1FE, 0x31FB08E2, 0x0E031B03);
	r0 = D(r0, s0_1_2, 0xF913E301, 0x17F41518, 0xFEFC0309, 0x0915ED17);
	r1 = D(r1, s0_1_2, 0x0003FEEF, 0xF4000C12, 0xFB040306, 0x020B0EFC);
	r2 = D(r2, s0_1_2, 0x05FA0D13, 0xFA100303, 0x04EBECFC, 0x05060D16);
	r3 = D(r3, s0_1_2, 0x0B0A0CDD, 0x01FCFE00, 0xFFFD06FC, 0x0302221A);
	r0 = D(r0, s0_2_0, 0xF226F5FF, 0xFBFF210C, 0x10FE0A06, 0x1B20012D);
	r1 = D(r1, s0_2_0, 0x080A03EF, 0x0503F701, 0xFBFFFF01, 0xF00401DB);
	r2 = D(r2, s0_2_0, 0xF2EEFDFB, 0xED05F9F7, 0x0F2FF71E, 0x01FC04F9);
	r3 = D(r3, s0_2_0, 0xDCF4FCEC, 0xE00C0003, 0x0FFD0210, 0x0716FEFF);
	r0 = D(r0, s0_2_1, 0x0013F325, 0x05FCE9EB, 0x22F704FC, 0xE81CF5E9);
	r1 = D(r1, s0_2_1, 0x1011030F, 0x07FC0A22, 0x050101FB, 0xD40E0010);
	r2 = D(r2, s0_2_1, 0x0700FDDE, 0x02121002, 0xF4F8E024, 0x13080211);
	r3 = D(r3, s0_2_1, 0x191AF71A, 0xF80905F8, 0x0FF8F627, 0xFA18F506);
	r0 = D(r0, s0_2_2, 0xE415F20D, 0xFC10110C, 0xFE00FC13, 0x0D26F8E4);
	r1 = D(r1, s0_2_2, 0x02030300, 0xFBF9F6ED, 0xFF07040B, 0x1402FE0A);
	r2 = D(r2, s0_2_2, 0xFD0404FB, 0x000C00FC, 0x0ADFFBB6, 0xFD030DF4);
	r3 = D(r3, s0_2_2, 0x170E10E9, 0xFA02FBF7, 0xFEFD130C, 0x07070504);
	r0 = D(r0, s1_0_0, 0xDC04EAA6, 0xF1EAE839, 0x0FF1FCD0, 0x06EBF039);
	r1 = D(r1, s1_0_0, 0x09080A88, 0x0B08DAE1, 0x06FDF603, 0x0F0F08D9);
	r2 = D(r2, s1_0_0, 0x00011618, 0xFBF0107F, 0xF6FD287F, 0x00FA0B34);
	r3 = D(r3, s1_0_0, 0xFAE7D87F, 0xEAF6F41E, 0x030237D7, 0x210307FD);
	r0 = D(r0, s1_0_1, 0xE32D594F, 0xF3EC24DF, 0xFE13FE14, 0x07F9EB81);
	r1 = D(r1, s1_0_1, 0xFCD6F1E3, 0xFF1CE5DB, 0x03F5EF0E, 0x07E904AE);
	r2 = D(r2, s1_0_1, 0xFCE6FDEA, 0x16070A30, 0x0133110E, 0x08FF06D1);
	r3 = D(r3, s1_0_1, 0x0EF3110B, 0xF6210710, 0x0B0F33FD, 0xF80C02CE);
	r0 = D(r0, s1_0_2, 0xF51D0233, 0xF90AFA3E, 0x03EE02D2, 0xF9ECE6F6);
	r1 = D(r1, s1_0_2, 0x07F10CDA, 0x000EF503, 0x0005F1F9, 0x0000FC30);
	r2 = D(r2, s1_0_2, 0x09F5000A, 0x10EEED0D, 0xF5C32081, 0x051E1981);
	r3 = D(r3, s1_0_2, 0x0C06F8A1, 0x01120AE8, 0xF7130701, 0xF6F7FF89);
	r0 = D(r0, s1_1_0, 0xF801F305, 0x19B7DD06, 0xEB000A0D, 0x2FDD0C05);
	r1 = D(r1, s1_1_0, 0x0AF6FA01, 0x0F01E618, 0xFAFDF800, 0xF10FE7EE);
	r2 = D(r2, s1_1_0, 0x29F91313, 0x1A0132EF, 0xEC1C350A, 0xDB07FE23);
	r3 = D(r3, s1_1_0, 0xEBF31303, 0x1B0A2BE3, 0xE809BE07, 0x0810050B);
	r0 = D(r0, s1_1_1, 0x01FF0C1B, 0xE41BB1F8, 0xED1E3C09, 0xC7DFED2C);
	r1 = D(r1, s1_1_1, 0x16EB1622, 0x1D00B9D9, 0xFA0DEC23, 0x17B7CF65);
	r2 = D(r2, s1_1_1, 0xEDEA5109, 0x28F6F522, 0xAE3B813A, 0xF9FEF6DF);
	r3 = D(r3, s1_1_1, 0xFF1A472B, 0x0613C91F, 0xEBFDDFFB, 0xDB04EEF5);
	r0 = D(r0, s1_1_2, 0x08180A1B, 0x00EE10ED, 0x0B100AEF, 0x01E4F300);
	r1 = D(r1, s1_1_2, 0x0BE7FAF9, 0x0DFEDB17, 0x0403FA0B, 0xFFDF0CE8);
	r2 = D(r2, s1_1_2, 0xDE0AE406, 0x05FDF21D, 0xF5AC200A, 0x0604EE16);
	r3 = D(r3, s1_1_2, 0xF91A1DDE, 0x02190506, 0xFE1405E3, 0xE2DD0F21);
	r0 = D(r0, s1_2_0, 0xFA0812F5, 0x06E82B08, 0x08FB07FC, 0xD410F706);
	r1 = D(r1, s1_2_0, 0xFF09F102, 0xEE00FBFC, 0x03FE0201, 0xF4181004);
	r2 = D(r2, s1_2_0, 0x0A0A11FE, 0x14080C16, 0x2EF61049, 0x070402FB);
	r3 = D(r3, s1_2_0, 0x0FFA11FE, 0x09FDFF01, 0xEDF41D01, 0x04FCFBFA);
	r0 = D(r0, s1_2_1, 0x0AF4FA06, 0xEB2511FF, 0x0307F3F3, 0x3A1EF4FC);
	r1 = D(r1, s1_2_1, 0x01E80D02, 0x09EFD707, 0xFCFA0108, 0xDEDC2F01);
	r2 = D(r2, s1_2_1, 0x140FF4F2, 0xFBFB28F4, 0x2C09EEAE, 0x0EFFEB0F);
	r3 = D(r3, s1_2_1, 0x2CFC0E04, 0x06F7040D, 0xEC0DE604, 0xF30DF108);
	r0 = D(r0, s1_2_2, 0x05F2F407, 0xF8F32D07, 0x08FF0509, 0xFD08C00C);
	r1 = D(r1, s1_2_2, 0x02F10307, 0x0B07EFFF, 0x00FD01FF, 0xF6EA03F6);
	r2 = D(r2, s1_2_2, 0x0D141700, 0x0312F1FB, 0xFD1FCAB2, 0x080DEDF2);
	r3 = D(r3, s1_2_2, 0x11148114, 0x04030D00, 0x05001300, 0x08FB100A);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(1.129e-02, -2.409e-02, -6.655e-03, 5.771e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.310e-02, 1.823e-02, -1.397e-02, 3.210e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-1.583e-02, 5.569e-03, -8.128e-03, 2.911e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-2.725e-02, -8.280e-03, -3.215e-02, 1.388e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-conv4
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv3
//!BIND LUMA
//!SAVE conv4
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv3_pt;
			r = conv3_gather(p, 0);
			g = conv3_gather(p, 1);
			b = conv3_gather(p, 2);
			a = conv3_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0E0D0D00, 0xF600F909, 0xF203060B, 0xF2FCF709);
	r1 = D(r1, s0_0_0, 0x0412FE02, 0xC6F50514, 0xF8F70AFA, 0x200A0BFB);
	r2 = D(r2, s0_0_0, 0x03EEF009, 0x0DF201FE, 0xFC0F0203, 0xF2F71108);
	r3 = D(r3, s0_0_0, 0xFBFEEE08, 0x818181A3, 0x06E7ED0E, 0x07F30CFC);
	r0 = D(r0, s0_0_1, 0x1BCF1004, 0xEF1D0304, 0xF5FA0CFE, 0xE3F4090F);
	r1 = D(r1, s0_0_1, 0x0508FAFD, 0xE41AE40E, 0xE6DD0EFB, 0x13190A06);
	r2 = D(r2, s0_0_1, 0xE525F21A, 0x0409F0FE, 0x030EFCFE, 0xEEFE0004);
	r3 = D(r3, s0_0_1, 0xF9060713, 0xE728F936, 0xB813EA19, 0x0BE9F8FA);
	r0 = D(r0, s0_0_2, 0x24F10C02, 0xFB1A0006, 0xF6FD0A06, 0xDA0F0F18);
	r1 = D(r1, s0_0_2, 0x06FEFE00, 0xF824D300, 0xF601F3F8, 0x20F62F0A);
	r2 = D(r2, s0_0_2, 0xDE07F71F, 0xF40E1406, 0x0601FDFA, 0xFC10FB02);
	r3 = D(r3, s0_0_2, 0x08F1F608, 0xDC151500, 0xFA111920, 0x01F6EDFC);
	r0 = D(r0, s0_1_0, 0x1C030600, 0xF5FDFD09, 0xDB04EF00, 0xFC00FF13);
	r1 = D(r1, s0_1_0, 0x06060701, 0xDE1712F2, 0x05F701FE, 0x11EF0F08);
	r2 = D(r2, s0_1_0, 0xFC080808, 0xFDE7070F, 0xF8FEFC05, 0xFC030205);
	r3 = D(r3, s0_1_0, 0xFDE5F60B, 0xC7061DE8, 0x030CFC09, 0x0AE6E7FD);
	r0 = D(r0, s0_1_1, 0x1C06110A, 0xE2FCFD0A, 0xF60A3A0D, 0x0B161C2D);
	r1 = D(r1, s0_1_1, 0x0DFB0203, 0xEED5D5FC, 0x150FEFFA, 0x220214FE);
	r2 = D(r2, s0_1_1, 0xFA3912FB, 0xFF35EC0F, 0x03220D08, 0xF2F11309);
	r3 = D(r3, s0_1_1, 0x0C00FEFB, 0x04FD2D06, 0xE7E214D8, 0x02DA0FF9);
	r0 = D(r0, s0_1_2, 0x1506F6FC, 0xEF08EF0F, 0xF7FEFB01, 0xFA1CF022);
	r1 = D(r1, s0_1_2, 0x0400F403, 0xE3BAF434, 0xF7EDF704, 0x1003FAF4);
	r2 = D(r2, s0_1_2, 0xD203120E, 0xEEFE2113, 0x030BF302, 0xFF0DEEFD);
	r3 = D(r3, s0_1_2, 0x0616EF02, 0xF8F30C1F, 0x0105ED13, 0x0C02EFFC);
	r0 = D(r0, s0_2_0, 0x1E000C0E, 0x04F90309, 0xE101F8F8, 0xE4FEF50A);
	r1 = D(r1, s0_2_0, 0x0A020605, 0xFDF6E9F9, 0xFD0503FF, 0x11FE0C13);
	r2 = D(r2, s0_2_0, 0xE2F60312, 0xF3F70B0D, 0x0405FBFE, 0xFE0702FF);
	r3 = D(r3, s0_2_0, 0x06F8F400, 0xD9E906E8, 0xE6080103, 0xF8020D07);
	r0 = D(r0, s0_2_1, 0x18011A12, 0xF3FCF5FC, 0xDBF607F1, 0xEF010806);
	r1 = D(r1, s0_2_1, 0x05FC0101, 0x0E0BDD01, 0x040509FC, 0x08F21319);
	r2 = D(r2, s0_2_1, 0xF9EAE412, 0xEEF604F5, 0xFFF7FD03, 0xF5F015E6);
	r3 = D(r3, s0_2_1, 0xFF03EC0A, 0xFF08FFF2, 0xF8000EE0, 0x100801FC);
	r0 = D(r0, s0_2_2, 0x110CF307, 0xF8FE09FE, 0x03FF1105, 0xF2F607FE);
	r1 = D(r1, s0_2_2, 0x0309F503, 0x0620CBFE, 0xFF13F4FA, 0x1507F804);
	r2 = D(r2, s0_2_2, 0xCCE71C0F, 0x00F21DF5, 0x06040201, 0xFA060709);
	r3 = D(r3, s0_2_2, 0xF8FAFC03, 0xFAF9080A, 0xF6FBFB05, 0x09F8F502);
	r0 = D(r0, s1_0_0, 0xF816FDFA, 0x001106F9, 0xEE1EE710, 0xFC07FC01);
	r1 = D(r1, s1_0_0, 0x04FBFFFA, 0xF6FCD7E1, 0xF5F6FF17, 0xE6FBFA04);
	r2 = D(r2, s1_0_0, 0xFEEBFDFF, 0x040402F9, 0x030EFAFD, 0xFAFCF805);
	r3 = D(r3, s1_0_0, 0xFF08F9FE, 0x81AEB681, 0xFBDA1910, 0xF1F508FC);
	r0 = D(r0, s1_0_1, 0xC618FE12, 0x17DE02EA, 0x0A0D11F7, 0x1CC5E40B);
	r1 = D(r1, s1_0_1, 0x0BFB04F7, 0x03FA10D4, 0xFF1D0030, 0x84E4F9ED);
	r2 = D(r2, s1_0_1, 0xFCDF0EFE, 0x0E03EFFA, 0x0C000AF6, 0xFF0D1001);
	r3 = D(r3, s1_0_1, 0x320FF805, 0x57FC07D7, 0x0117DA13, 0xE800030B);
	r0 = D(r0, s1_0_2, 0xE305041A, 0xFDFBFEF5, 0xEA090705, 0x08F8F50D);
	r1 = D(r1, s1_0_2, 0xFF03FC02, 0xFE08FBF7, 0x1FFD03FB, 0xD50BFB1B);
	r2 = D(r2, s1_0_2, 0xE401021A, 0x0E0400F3, 0x02F70100, 0xF203FD08);
	r3 = D(r3, s1_0_2, 0x0703FDF2, 0x05FAFFFD, 0xE50F2112, 0xEA00FEFB);
	r0 = D(r0, s1_1_0, 0x0526F8FF, 0xFEFDFC01, 0xEA35CF06, 0xFCFAEB01);
	r1 = D(r1, s1_1_0, 0x04E5190E, 0xD5FBF912, 0xFAFEFC04, 0xFBFC0A00);
	r2 = D(r2, s1_1_0, 0x0712F4F1, 0x05EE19F5, 0xFD25EDF9, 0x09BB1104);
	r3 = D(r3, s1_1_0, 0x02250502, 0x0D231507, 0xE22AEBE8, 0xF8EDEC03);
	r0 = D(r0, s1_1_1, 0xC9ACEF1B, 0x0F3812EC, 0x17FF15D2, 0x1381DCE3);
	r1 = D(r1, s1_1_1, 0x02370DFC, 0x1FDFEC14, 0xEACCE016, 0xB8FE1CFB);
	r2 = D(r2, s1_1_1, 0x3CB8B60E, 0x10E12CF1, 0x142B05D5, 0x19150414);
	r3 = D(r3, s1_1_1, 0xF7A60A27, 0x214E0407, 0x101EDB2D, 0x2844F9FE);
	r0 = D(r0, s1_1_2, 0xC602FB0C, 0x04F9FBF4, 0xEF0CF5F9, 0xFEBDCE0A);
	r1 = D(r1, s1_1_2, 0xF60BFEFD, 0x070E0B13, 0xF7FAFB03, 0xCEEFFB0D);
	r2 = D(r2, s1_1_2, 0xE31EDA15, 0x1B080C0E, 0xFEFE01F6, 0xF6F4F3FB);
	r3 = D(r3, s1_1_2, 0x06FC0610, 0xDE0FFB0A, 0xF2F20BDE, 0xFA0AFA00);
	r0 = D(r0, s1_2_0, 0xFB17E3FF, 0xFFF4020B, 0xFAFFFF02, 0xF80FEEF1);
	r1 = D(r1, s1_2_0, 0x02F6FEFE, 0xF1F2061D, 0xFB0BFFF3, 0xF614E307);
	r2 = D(r2, s1_2_0, 0x08F8DCFA, 0x05FBFD00, 0xFF020512, 0xFCFDF701);
	r3 = D(r3, s1_2_0, 0x01FCFB06, 0xEFFEF4F8, 0x0303F6DA, 0x0016010A);
	r0 = D(r0, s1_2_1, 0xEE00FA17, 0xFCF801FE, 0x0714FFF7, 0x06EED409);
	r1 = D(r1, s1_2_1, 0x00010809, 0x0116FDF2, 0xFE05FC03, 0xEC13E803);
	r2 = D(r2, s1_2_1, 0x0BFDDBFA, 0x0B17F5E6, 0x00FFFEF8, 0x061308FA);
	r3 = D(r3, s1_2_1, 0xF9FE0700, 0x01F5FAFA, 0x0F112B2E, 0xF7FE010D);
	r0 = D(r0, s1_2_2, 0xFB14F9FA, 0x02FB0503, 0xFC02FE09, 0x01FEE319);
	r1 = D(r1, s1_2_2, 0x00F6FDFC, 0x082611F4, 0xFE0CFF06, 0xEA0DF317);
	r2 = D(r2, s1_2_2, 0x17EEF7F8, 0x02FA05F3, 0xFC010406, 0x01FB0002);
	r3 = D(r3, s1_2_2, 0x0AF901F4, 0xFEE9FD09, 0x07EFF6F1, 0xFD05FCFA);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x00F604F3, 0xFFF7F2FB, 0x072F09F9, 0x00FD0EF9);
	r1 = D(r1, s0_0_0, 0xF404FA01, 0x41E1FE14, 0x0EF602F9, 0x070A0F05);
	r2 = D(r2, s0_0_0, 0xFA0EFF15, 0xFC060805, 0xF308FEFD, 0xF91E1009);
	r3 = D(r3, s0_0_0, 0xE90607FF, 0xA18EFA81, 0xF8F90B0A, 0x08270603);
	r0 = D(r0, s0_0_1, 0x0DF613FD, 0x04F2FDF3, 0x03FCFE01, 0xF9EE13F9);
	r1 = D(r1, s0_0_1, 0xF8FC0600, 0x25E1E902, 0x0F0F00F9, 0xFBF30DF2);
	r2 = D(r2, s0_0_1, 0x1704FB13, 0xFAFD07FE, 0x01F9FAFB, 0xFAF5FB03);
	r3 = D(r3, s0_0_1, 0xF4FC2202, 0x031D011E, 0xF519FD08, 0xFD09E7F5);
	r0 = D(r0, s0_0_2, 0xFA0202F7, 0x00FDFDFF, 0xF801FC0A, 0x08F20E00);
	r1 = D(r1, s0_0_2, 0xFD0104FA, 0x0A00DB0A, 0xFBF9F80D, 0x010F06FF);
	r2 = D(r2, s0_0_2, 0xE505F303, 0xFB01FF10, 0xFAFF0200, 0x0002F904);
	r3 = D(r3, s0_0_2, 0x04090304, 0xE9FE002A, 0x00F2F1F9, 0xF9FDFEFA);
	r0 = D(r0, s0_1_0, 0x12040C0C, 0xFCFBFC06, 0xECF3F4FB, 0xFC02F9FF);
	r1 = D(r1, s0_1_0, 0x0EFB0C06, 0x3F1F4CCF, 0x0DF209F8, 0x1E0D100E);
	r2 = D(r2, s0_1_0, 0x0B0E35F5, 0xF11903F7, 0xF3F3F7F8, 0xE72C17F2);
	r3 = D(r3, s0_1_0, 0xF8EFFCE4, 0xD9EE3D9F, 0xBC07FA01, 0x08270204);
	r0 = D(r0, s0_1_1, 0x16F8C80C, 0xFA0CFFE1, 0xFC19E9BA, 0xEEF7FAF5);
	r1 = D(r1, s0_1_1, 0xFC070D08, 0xED0D20B3, 0x07F90104, 0x1E05FE11);
	r2 = D(r2, s0_1_1, 0x101929C3, 0x022C34D9, 0x0F12F7EE, 0xE6FE1A0C);
	r3 = D(r3, s0_1_1, 0xFBFDDB17, 0xE9FA5FE8, 0x032113B2, 0x0E07E931);
	r0 = D(r0, s0_1_2, 0x120900F3, 0x00FC02FD, 0x0B00FF09, 0x02FC1608);
	r1 = D(r1, s0_1_2, 0x0102F7FB, 0xC6F816F5, 0xE60A0AF6, 0xFC0B01EF);
	r2 = D(r2, s0_1_2, 0x191616E2, 0xED080C13, 0x03000308, 0x05F9EAFF);
	r3 = D(r3, s0_1_2, 0x12F9FBFF, 0xF308FFFF, 0x0100DC03, 0x15F9FBEA);
	r0 = D(r0, s0_2_0, 0xF919F809, 0x06000000, 0xFB0106F9, 0x03F90400);
	r1 = D(r1, s0_2_0, 0xFF07FE02, 0x0A02DE02, 0xF9F20801, 0x0611F6FD);
	r2 = D(r2, s0_2_0, 0xE3F00106, 0x00F5FFFB, 0xFF0107FD, 0x040BF9FC);
	r3 = D(r3, s0_2_0, 0x0002FCFD, 0x13E2F90E, 0xEAFC1CF0, 0xF60E1307);
	r0 = D(r0, s0_2_1, 0xF821F9FE, 0x03FA0607, 0xFF0AFCEA, 0x0805F8F6);
	r1 = D(r1, s0_2_1, 0xFB030106, 0xFC0604F7, 0x0705EAFD, 0xF714F20E);
	r2 = D(r2, s0_2_1, 0x0623FBFA, 0x0CFC04F8, 0x0105FF00, 0xEC030808);
	r3 = D(r3, s0_2_1, 0xFCF701FC, 0x1517F50E, 0x07FEFAE7, 0xF3071705);
	r0 = D(r0, s0_2_2, 0x0C0003F8, 0xF901FC08, 0x01020606, 0x05FAF709);
	r1 = D(r1, s0_2_2, 0x03FD01FE, 0x211DD605, 0x150AFCF6, 0x0705FFFA);
	r2 = D(r2, s0_2_2, 0xDA00DE13, 0xF803EA10, 0xFC020002, 0xFAFF040E);
	r3 = D(r3, s0_2_2, 0xFAF6FBFF, 0x03FEF705, 0xFEE8FC02, 0xF9F90E1A);
	r0 = D(r0, s1_0_0, 0x05FAF4AA, 0xFA020CF5, 0x0B09F314, 0xFF0705FC);
	r1 = D(r1, s1_0_0, 0x030504FC, 0x1AF3F5D6, 0x00FC00EE, 0xFE0BF1A7);
	r2 = D(r2, s1_0_0, 0xF0FAFEEA, 0xFEFEFFF0, 0x0906000A, 0xFAFEF107);
	r3 = D(r3, s1_0_0, 0x00FBFD02, 0x81818BF7, 0xF9EAE91A, 0xF9F8F90C);
	r0 = D(r0, s1_0_1, 0x0DF0F4E7, 0x0D04FEF9, 0xE6FFF812, 0x00FE0F27);
	r1 = D(r1, s1_0_1, 0xFFF70A00, 0x1CFCEB89, 0xDF0014CE, 0xFDF4F8D1);
	r2 = D(r2, s1_0_1, 0x1A06030A, 0xFCE7F9FF, 0xFE070B09, 0x03FD0B06);
	r3 = D(r3, s1_0_1, 0x0C08F903, 0xDC03F1F2, 0x0A33ED1E, 0x0B140018);
	r0 = D(r0, s1_0_2, 0xF1100FF0, 0xF9FC0302, 0xF0EFFD08, 0x01FD1F0F);
	r1 = D(r1, s1_0_2, 0xFCFC0404, 0xF9010AD4, 0xFD120EF4, 0xF4120AF6);
	r2 = D(r2, s1_0_2, 0xF90705F1, 0x00FA0509, 0xFBFD0D06, 0xFAF4F303);
	r3 = D(r3, s1_0_2, 0xF8F8FF06, 0x01F5FE00, 0xE6D1E506, 0x06F8FFFA);
	r0 = D(r0, s1_1_0, 0xFDFEF0E7, 0xFA0103EC, 0x14020BEC, 0x0FFC0C12);
	r1 = D(r1, s1_1_0, 0xF10AFE03, 0xA51BC6B3, 0xF8FDF0FF, 0xE709F2E0);
	r2 = D(r2, s1_1_0, 0x1301FB14, 0xEA0CFFFC, 0x15F9FDF1, 0xE80EEC0B);
	r3 = D(r3, s1_1_0, 0x0504140A, 0x2F04F611, 0x00EDFF0B, 0x0AF4F3DC);
	r0 = D(r0, s1_1_1, 0xF4DA0C07, 0x050C0CEC, 0x0812E908, 0xF71CFE14);
	r1 = D(r1, s1_1_1, 0x0F032003, 0xC8FF2607, 0xF012EF03, 0x11D6F81C);
	r2 = D(r2, s1_1_1, 0x0116EC0D, 0xE5FB0FFA, 0x1E02E3F7, 0xFEEF0B02);
	r3 = D(r3, s1_1_1, 0x10F5190E, 0x0C0A161B, 0x253ECF02, 0xF110EF0E);
	r0 = D(r0, s1_1_2, 0xFA0009F7, 0xF300F3F9, 0xF4E9DFFC, 0xFF011EFD);
	r1 = D(r1, s1_1_2, 0xFF00FEFF, 0xC8FC1F0B, 0xFCED3502, 0x09132BF8);
	r2 = D(r2, s1_1_2, 0xFBCD1709, 0xF8EDF506, 0x00F3F0FC, 0xFD06ECFE);
	r3 = D(r3, s1_1_2, 0x0008EDF7, 0xF2DFF9FA, 0xFDA2F5FD, 0xF5FFF20B);
	r0 = D(r0, s1_2_0, 0x040406EF, 0xF6000204, 0x02FB0509, 0x0DFD0509);
	r1 = D(r1, s1_2_0, 0xFE010004, 0xDAF00D06, 0x02FAF9F5, 0xFB0506F4);
	r2 = D(r2, s1_2_0, 0x03110702, 0x0E0A0905, 0xFE0102FC, 0xF5060903);
	r3 = D(r3, s1_2_0, 0x03000600, 0xF30FF807, 0x09F1FB0C, 0x040DFB0A);
	r0 = D(r0, s1_2_1, 0xEFF306F6, 0xFC0A05FE, 0x0C00FF07, 0x0B0D100E);
	r1 = D(r1, s1_2_1, 0x0304FDFE, 0xD61EF6EF, 0xF9F90100, 0xFDF70DF6);
	r2 = D(r2, s1_2_1, 0xF40B1004, 0x1D0105FE, 0x00FE04FF, 0x0506080B);
	r3 = D(r3, s1_2_1, 0xFCF8FCFB, 0x051B0F02, 0xFC050400, 0xFB18F507);
	r0 = D(r0, s1_2_2, 0xF3EFF9F4, 0x03051500, 0xF8091004, 0x090DFEFF);
	r1 = D(r1, s1_2_2, 0x02FBFEFE, 0x0505FAFF, 0xF303F4FA, 0xEDFEE7F9);
	r2 = D(r2, s1_2_2, 0x08D40E01, 0x06080F08, 0xFF0105FE, 0x0006FA02);
	r3 = D(r3, s1_2_2, 0xFFF60102, 0x06050404, 0x0906030B, 0x0401FEFB);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(4.183e-02, -2.019e-02, 2.978e-02, -3.248e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.630e-02, -6.091e-02, -3.774e-03, 2.081e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-3.593e-02, -2.567e-02, 4.652e-03, 2.630e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.011e-02, -1.720e-02, -1.617e-02, 1.644e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-conv5
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv4
//!BIND LUMA
//!SAVE conv5
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv4_pt;
			r = conv4_gather(p, 0);
			g = conv4_gather(p, 1);
			b = conv4_gather(p, 2);
			a = conv4_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x07100D0E, 0x000506FA, 0x00F8EB0C, 0xFEFDFBEB);
	r1 = D(r1, s0_0_0, 0xF90009FC, 0xFA0203FF, 0x03F90006, 0xF4070906);
	r2 = D(r2, s0_0_0, 0xFAFB05F0, 0xFDFD0617, 0xF80F0D05, 0x0602FAF8);
	r3 = D(r3, s0_0_0, 0x1E07EFE2, 0xFEFF05F6, 0x0501FE05, 0x02F52307);
	r0 = D(r0, s0_0_1, 0xDFE01902, 0xFFFCFB07, 0x08F308F0, 0xE4E60AD1);
	r1 = D(r1, s0_0_1, 0xF90F070B, 0x0516FDF9, 0x0A00FF03, 0xFB12190F);
	r2 = D(r2, s0_0_1, 0xFB0600FF, 0xF5020D24, 0x06FE08FD, 0x09170100);
	r3 = D(r3, s0_0_1, 0xF6FAEAEB, 0x000402E8, 0x06FBFF08, 0x0716E11C);
	r0 = D(r0, s0_0_2, 0xEC1100FC, 0x00EEF905, 0xF80BFC05, 0x0E0713EA);
	r1 = D(r1, s0_0_2, 0xF607020D, 0x07FE10FF, 0x04FD0309, 0xFF020206);
	r2 = D(r2, s0_0_2, 0xFDFF0204, 0xFA0A0A12, 0xF2090401, 0x0001FBFC);
	r3 = D(r3, s0_0_2, 0x05F80E0B, 0x02FDFA03, 0xFFFF0101, 0xFFE70B05);
	r0 = D(r0, s0_1_0, 0x18112F01, 0xF32CF2F1, 0x0F0AF4F1, 0xFE05EEFD);
	r1 = D(r1, s0_1_0, 0xE8EC0C11, 0xFB08EF02, 0x130B06F7, 0x05040CF9);
	r2 = D(r2, s0_1_0, 0xF7E504F4, 0x08F51611, 0xF1FE080A, 0xF721FDEE);
	r3 = D(r3, s0_1_0, 0xEEDDEFE3, 0x0A07FCF8, 0x040602FD, 0xF013070D);
	r0 = D(r0, s0_1_1, 0x281AFD0D, 0xFAEE0605, 0xFF0ADEDF, 0xE93515F8);
	r1 = D(r1, s0_1_1, 0x01FEF102, 0xDF0125FA, 0x1B17DFF7, 0x0CFCEC1A);
	r2 = D(r2, s0_1_1, 0x0EF1F7F3, 0x18E7F636, 0x012BFAE4, 0x01250EF1);
	r3 = D(r3, s0_1_1, 0x04E90EE1, 0xE3F407F1, 0xFDFCF5F8, 0xF32CE607);
	r0 = D(r0, s0_1_2, 0xF7FB03F6, 0x02F9FEFF, 0xF8F71D05, 0x08FB03FD);
	r1 = D(r1, s0_1_2, 0x06E4040D, 0x0E13DC13, 0x09E4F90A, 0xF4090C05);
	r2 = D(r2, s0_1_2, 0x01FD04FF, 0xF70E0F10, 0x02ECFC0C, 0xF802FDFB);
	r3 = D(r3, s0_1_2, 0x04020507, 0xF30212EE, 0xFCF9FA07, 0xFFDEED09);
	r0 = D(r0, s0_2_0, 0x0201020B, 0xFB0E1AFF, 0xFE0A0311, 0x0AF9F102);
	r1 = D(r1, s0_2_0, 0xF9FBFA03, 0xF907F5FD, 0x12000E02, 0xF4F52106);
	r2 = D(r2, s0_2_0, 0xFF0B13FE, 0x05F31701, 0x031202FF, 0x0608F8FD);
	r3 = D(r3, s0_2_0, 0x0508000C, 0xFE050E04, 0x05030602, 0xF4FCE206);
	r0 = D(r0, s0_2_1, 0xE3112D10, 0xFF190AFE, 0xF9FAD8E3, 0x05071803);
	r1 = D(r1, s0_2_1, 0x04FF1308, 0xF603FDFD, 0x1308280C, 0x0E0D0F0D);
	r2 = D(r2, s0_2_1, 0x07FFF90C, 0x09F21112, 0xEFEF18EE, 0x0602F1ED);
	r3 = D(r3, s0_2_1, 0xFE0F1B14, 0x0A121A0A, 0x0405040B, 0x000F18FD);
	r0 = D(r0, s0_2_2, 0xF6FD0BF4, 0xFFFE0203, 0x0505120D, 0x08FC00FA);
	r1 = D(r1, s0_2_2, 0xFAF9020C, 0x01040B0C, 0x00F7FB03, 0x00090AFC);
	r2 = D(r2, s0_2_2, 0xFDF800F9, 0xF3000409, 0xFD050E07, 0x01000003);
	r3 = D(r3, s0_2_2, 0x00FD0006, 0xFEFC0103, 0xFC00FB0A, 0x02D6EB09);
	r0 = D(r0, s1_0_0, 0xF9F8EAFF, 0xF6FAF304, 0xFD0911FC, 0xE6F6F903);
	r1 = D(r1, s1_0_0, 0xFAF0E900, 0xFDFCFEFE, 0xFD00FA02, 0x06FEFE06);
	r2 = D(r2, s1_0_0, 0xECF7D706, 0xFE03F9FE, 0x00070B06, 0x0A0202FE);
	r3 = D(r3, s1_0_0, 0x02F6F2DF, 0xF6040D02, 0x050101FA, 0xF4E60F02);
	r0 = D(r0, s1_0_1, 0xFEF4F2F5, 0x020703FF, 0xF8EDFE0C, 0x9A04E5FD);
	r1 = D(r1, s1_0_1, 0xF5F9EEFC, 0xFCFFFA0B, 0x06FFFFF4, 0xFAF8EC02);
	r2 = D(r2, s1_0_1, 0xF0F9F103, 0xF0F3F903, 0x0D0CFEF4, 0xFCFDFE16);
	r3 = D(r3, s1_0_1, 0xF4F5F126, 0xFB0AEC00, 0xFEFDFB0E, 0x0C140004);
	r0 = D(r0, s1_0_2, 0xF9FDFF18, 0x02FC00F2, 0xF4060318, 0xE00FFCFD);
	r1 = D(r1, s1_0_2, 0xFBFDFC0A, 0x07FDF5DC, 0xFFFCFD02, 0xFDFB00FC);
	r2 = D(r2, s1_0_2, 0xFFF8F1FC, 0xFCFC000D, 0x04F8F7FB, 0xFD00F90D);
	r3 = D(r3, s1_0_2, 0xF7F70DFB, 0x060A1100, 0x01FFFFF9, 0x010D0D00);
	r0 = D(r0, s1_1_0, 0x07070DFB, 0x0B2E0A03, 0xFFF6F2E1, 0xFE0E0EF5);
	r1 = D(r1, s1_1_0, 0xED020702, 0x0006FEFB, 0x050D030C, 0x1309E8E6);
	r2 = D(r2, s1_1_0, 0xDBFF05EE, 0x020609DE, 0xF60F1F0A, 0xFF07E601);
	r3 = D(r3, s1_1_0, 0xF3052819, 0x011D2300, 0x0709FF0B, 0xF5EFF213);
	r0 = D(r0, s1_1_1, 0xE8F6BCCC, 0xFCE61513, 0xEFF8F215, 0xE41EE3CD);
	r1 = D(r1, s1_1_1, 0x07132DBD, 0x02F8FD0C, 0x1424F80C, 0xE7101FE7);
	r2 = D(r2, s1_1_1, 0xF308F5C0, 0xF11F20C8, 0xFF1FE7FD, 0x0400EA22);
	r3 = D(r3, s1_1_1, 0x0B0A1EE4, 0xF4172314, 0xFE190352, 0x27EADBCC);
	r0 = D(r0, s1_1_2, 0x12F0F713, 0x0301E8F8, 0xE5F2EBFF, 0xE805FDE2);
	r1 = D(r1, s1_1_2, 0xF3050AEA, 0xEC10FDEA, 0xF50705FF, 0x0700F7ED);
	r2 = D(r2, s1_1_2, 0x0103F9FF, 0xF4F90507, 0x03FC1AEB, 0x06FAF5F7);
	r3 = D(r3, s1_1_2, 0xEBFA16FE, 0x05FBFA0B, 0xFFFFFDEF, 0xEB0DDCE2);
	r0 = D(r0, s1_2_0, 0x050B07FF, 0xFB020900, 0x04E5060A, 0x0310F616);
	r1 = D(r1, s1_2_0, 0xFD0D00FB, 0x0005FD05, 0x02010805, 0x05F428F5);
	r2 = D(r2, s1_2_0, 0xF904F1F4, 0xFFEB07FB, 0x1002F9E8, 0xFF06050C);
	r3 = D(r3, s1_2_0, 0xFE02E9F4, 0xF8F9FB01, 0xFFFDF8FF, 0x0001150B);
	r0 = D(r0, s1_2_1, 0xF3033900, 0xFD23F608, 0xF61515FA, 0x01F51915);
	r1 = D(r1, s1_2_1, 0xEA08FE05, 0x020FEBF8, 0xE5F7020C, 0xE842FE09);
	r2 = D(r2, s1_2_1, 0xEE05F60F, 0xFFFCFCFF, 0x02112405, 0x03FEFD15);
	r3 = D(r3, s1_2_1, 0xF303EBF2, 0xFF0FEBF4, 0xFA09F700, 0x0BCECC0A);
	r0 = D(r0, s1_2_2, 0x0FF10CF4, 0xFC070B01, 0xE9F9E1FF, 0x0DF62F0C);
	r1 = D(r1, s1_2_2, 0xE806F410, 0xEB05FDF5, 0xF90FFB09, 0x04031A0A);
	r2 = D(r2, s1_2_2, 0x07FBF005, 0xFF0B0608, 0xF50F0F02, 0x00FEFE02);
	r3 = D(r3, s1_2_2, 0x00F5D0F6, 0xEE06FCFB, 0xF702FDF8, 0xF8F4E3F9);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x13F2FE04, 0xFAF4FF0B, 0x080B0804, 0xFD050906);
	r1 = D(r1, s0_0_0, 0x01FA0314, 0xFAFA020E, 0xFE070200, 0x03FD0009);
	r2 = D(r2, s0_0_0, 0x00FF0C12, 0xFBFE0A04, 0x02F50412, 0x0C040004);
	r3 = D(r3, s0_0_0, 0xFAFC1700, 0xF9FF0311, 0xFF000202, 0x0E010008);
	r0 = D(r0, s0_0_1, 0xDC0AEA06, 0x14FF08F3, 0xDE05FD07, 0x131004FD);
	r1 = D(r1, s0_0_1, 0x06FA120C, 0xFBFF0013, 0x040AF703, 0x14EE13FD);
	r2 = D(r2, s0_0_1, 0x0AF819FC, 0xF2F7110A, 0xF901F10D, 0x10E808EE);
	r3 = D(r3, s0_0_1, 0xF60432E3, 0x0B0A17F7, 0xF40F0C0A, 0x1EFBE904);
	r0 = D(r0, s0_0_2, 0xDED8EF05, 0xF819FDFA, 0x04D5060B, 0xF1F40103);
	r1 = D(r1, s0_0_2, 0xF6FA0703, 0x160DF9FA, 0x00FA0009, 0xEFF80003);
	r2 = D(r2, s0_0_2, 0xFBF90C06, 0x0BEA0905, 0x02F9F708, 0x06FA0004);
	r3 = D(r3, s0_0_2, 0xD7F91209, 0xE70808FC, 0x08000301, 0x0F28F906);
	r0 = D(r0, s0_1_0, 0x06F7060E, 0x00F2040C, 0x0CECEC0C, 0xFD0407FD);
	r1 = D(r1, s0_1_0, 0xFF141111, 0xFFF8FDFF, 0xFFF9F907, 0x16030214);
	r2 = D(r2, s0_1_0, 0x0F1CFA07, 0x0BEEEF01, 0xFB0D0C0F, 0xEFE51615);
	r3 = D(r3, s0_1_0, 0x0E28070A, 0x0206FD00, 0xF9FAF9F9, 0xE1EC1710);
	r0 = D(r0, s0_1_1, 0xDBD02901, 0x180BEBEA, 0xF3074BF9, 0xF3EC1628);
	r1 = D(r1, s0_1_1, 0x0CFB0F2D, 0x0E22F909, 0xF0E5072B, 0xFFF42D1A);
	r2 = D(r2, s0_1_1, 0x17111708, 0xE3EE0A1D, 0x28162017, 0x21D9EB03);
	r3 = D(r3, s0_1_1, 0xF708DE0A, 0xEE09030E, 0xE417F905, 0x0CC6CA15);
	r0 = D(r0, s0_1_2, 0xD7F101FD, 0xE4FFFCFE, 0xD8F8E906, 0x1BFC0DF9);
	r1 = D(r1, s0_1_2, 0x0010110E, 0x28FF18FB, 0x18210A01, 0x01F8EC0B);
	r2 = D(r2, s0_1_2, 0xF605F405, 0x08F20606, 0x051D0B06, 0xF004F203);
	r3 = D(r3, s0_1_2, 0x0AF5FDFE, 0xF3E4EE07, 0x171903FC, 0x172709FE);
	r0 = D(r0, s0_2_0, 0x03031A09, 0x05F00504, 0xF9EB0BFE, 0xFD06F701);
	r1 = D(r1, s0_2_0, 0x01030900, 0xF8FBFE01, 0xFB050406, 0x0206F40D);
	r2 = D(r2, s0_2_0, 0x04FF0908, 0x0200F4FE, 0x07EDF406, 0x01FEF608);
	r3 = D(r3, s0_2_0, 0xFBF705FD, 0x01F60200, 0xFEF7FFFB, 0x04110E0B);
	r0 = D(r0, s0_2_1, 0x0F0AF512, 0xFEEE0401, 0x1907FE0A, 0x0FF3F010);
	r1 = D(r1, s0_2_1, 0xFF050507, 0xFE0A0308, 0xFAF50404, 0xF9FB1408);
	r2 = D(r2, s0_2_1, 0xF9F704FF, 0xF7FA0802, 0xF509F309, 0x00FE06FE);
	r3 = D(r3, s0_2_1, 0x04EFFEFB, 0x00E40BFD, 0xF2FB0200, 0x05F7D504);
	r0 = D(r0, s0_2_2, 0xFB03F403, 0x0A01FCFE, 0x00F902FE, 0xFFF9FD01);
	r1 = D(r1, s0_2_2, 0x000A0302, 0x010101FF, 0xF30AFF04, 0x07F7F706);
	r2 = D(r2, s0_2_2, 0x0002FB04, 0x07FCF805, 0x0BEEFA07, 0x08FB02FD);
	r3 = D(r3, s0_2_2, 0x010F0003, 0xF7FFFE06, 0x0105FFFE, 0x0D050BFB);
	r0 = D(r0, s1_0_0, 0xFD0AFFFD, 0x021305FE, 0xF8F306F9, 0x03F1FD03);
	r1 = D(r1, s1_0_0, 0x05FB0207, 0x00FFFF01, 0x01FA00FC, 0xFC0B00FD);
	r2 = D(r2, s1_0_0, 0x1DE6FB07, 0x02F7F8FB, 0x090001FA, 0xFE0902FF);
	r3 = D(r3, s1_0_0, 0xEB1CF903, 0x060904FE, 0xFC05FEFD, 0x0D020209);
	r0 = D(r0, s1_0_1, 0xEAEBF40E, 0x12EB05FB, 0xEC02F703, 0x00F210F0);
	r1 = D(r1, s1_0_1, 0x17FFF5FD, 0x1317FCFD, 0xF4020001, 0x0C0C02FC);
	r2 = D(r2, s1_0_1, 0x160605F5, 0xFA0E0401, 0xF0000508, 0xFF02FC02);
	r3 = D(r3, s1_0_1, 0xE5F515F2, 0x28EBFCFD, 0xFB01FE02, 0xF52413ED);
	r0 = D(r0, s1_0_2, 0x02FCEA06, 0xFCF4FB04, 0xFE14FF02, 0x0A0A04E7);
	r1 = D(r1, s1_0_2, 0xFF060D0A, 0xF2040613, 0xF403FC04, 0xF8040701);
	r2 = D(r2, s1_0_2, 0xF4FF0115, 0xFB060A05, 0xFCFC0602, 0xF90002FE);
	r3 = D(r3, s1_0_2, 0xFFFB05FA, 0x0FF7F8FA, 0xFAFC00FE, 0xF4F10209);
	r0 = D(r0, s1_1_0, 0xF80B08FD, 0x00F9F9E8, 0x0F21ED10, 0x02EF0909);
	r1 = D(r1, s1_1_0, 0x0CE402F0, 0xFE09FC00, 0xFA06FF06, 0xFD10FEF2);
	r2 = D(r2, s1_1_0, 0x02F209F4, 0xF00BFE08, 0x02E710DE, 0x000EF808);
	r3 = D(r3, s1_1_0, 0x0203090D, 0x03FAFEF0, 0xF80401FF, 0x13E90521);
	r0 = D(r0, s1_1_1, 0x1FB6CCFA, 0xFCEE17DE, 0xE0FAFFE7, 0xF2F51621);
	r1 = D(r1, s1_1_1, 0xE0131809, 0x051A1AD6, 0xFDFEF107, 0xB90910F9);
	r2 = D(r2, s1_1_1, 0xF2E81920, 0xF3ECEF2F, 0xE6EE14DD, 0xEC0A26EF);
	r3 = D(r3, s1_1_1, 0x0C062C14, 0x0F0417CB, 0x02061CFE, 0xEC281CF8);
	r0 = D(r0, s1_1_2, 0xFCF3CE12, 0x0D00EEFF, 0xFB0B0F0D, 0xE7FC251A);
	r1 = D(r1, s1_1_2, 0xF7F40517, 0xECF60A0F, 0xF8FC01FE, 0x040EF9FC);
	r2 = D(r2, s1_1_2, 0x0111F208, 0xF3091713, 0xFEFAE1FF, 0x03F8FC09);
	r3 = D(r3, s1_1_2, 0x030405F5, 0x070E24F3, 0xFEF80206, 0x030A15F7);
	r0 = D(r0, s1_2_0, 0x050D0C12, 0xF904FB05, 0x0F14FFEB, 0xFC0107FF);
	r1 = D(r1, s1_2_0, 0x0101FD05, 0x01FAFFFE, 0xFBFB0A04, 0xFFFFFAEB);
	r2 = D(r2, s1_2_0, 0x0303FA1A, 0xF9FAFA0D, 0x03FAF5FB, 0x040505FE);
	r3 = D(r3, s1_2_0, 0x0100FBFF, 0x0206FF07, 0xFD05FC00, 0x0406FFFD);
	r0 = D(r0, s1_2_1, 0xF9EA2BFF, 0xFEF60BFD, 0x00251016, 0x0508F9E8);
	r1 = D(r1, s1_2_1, 0xF9FAF71B, 0x0805EAF8, 0x04FE2000, 0x00FB0BE8);
	r2 = D(r2, s1_2_1, 0xFEF70B00, 0x0210DB03, 0xFDFFF7F9, 0xF9FEF412);
	r3 = D(r3, s1_2_1, 0xFEF9F5F3, 0x06FB0302, 0x02F80EFD, 0xEE070DE5);
	r0 = D(r0, s1_2_2, 0x01F1C712, 0x01F6EDFB, 0xFC056AF1, 0x03097F09);
	r1 = D(r1, s1_2_2, 0xFC059DFF, 0xF908D602, 0xFD049000, 0xFDFF51F7);
	r2 = D(r2, s1_2_2, 0xFEFE85F8, 0xFA0D7FFE, 0xF904C6E7, 0x01FFE805);
	r3 = D(r3, s1_2_2, 0x08004701, 0x03F781F5, 0xFFFE36FA, 0x0F04BCE7);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-5.941e-03, -9.372e-03, -7.002e-03, -4.919e-03);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-1.668e-02, -2.272e-02, 2.249e-02, -1.083e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-8.417e-03, -2.250e-03, -3.500e-02, -1.345e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.574e-02, 8.068e-03, -1.404e-05, -1.553e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-conv6
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv5
//!BIND LUMA
//!SAVE conv6
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv5_pt;
			r = conv5_gather(p, 0);
			g = conv5_gather(p, 1);
			b = conv5_gather(p, 2);
			a = conv5_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0, r1, r2, r3;
	vec4 f0, f1, f2, f3;
	r0 = ivec4(0); r1 = ivec4(0); r2 = ivec4(0); r3 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x001C060B, 0x000705F9, 0xF80D050B, 0xF708FEFE);
	r1 = D(r1, s0_0_0, 0xFFFD03FE, 0x07FD08FF, 0xFFF00202, 0x01030200);
	r2 = D(r2, s0_0_0, 0xEBE901FF, 0x0B1413F9, 0xFEF802FB, 0x032B04E1);
	r3 = D(r3, s0_0_0, 0xEF11F4FD, 0x040A00FC, 0x0EE223B0, 0xFF0304FF);
	r0 = D(r0, s0_0_1, 0xF3D9F11D, 0x060F0502, 0xF2F0F0F8, 0xF9EFF7F8);
	r1 = D(r1, s0_0_1, 0x080C0BFD, 0xFF2AF6EF, 0x0FFB07F9, 0x06050D06);
	r2 = D(r2, s0_0_1, 0xF7020708, 0xFF05F7F9, 0x0101FC02, 0xFBC90002);
	r3 = D(r3, s0_0_1, 0x0F06FAD5, 0x000406FB, 0x0226F802, 0x00010203);
	r0 = D(r0, s0_0_2, 0xF80A08F8, 0xFFF9FC00, 0xF40A02FA, 0xFB0100F8);
	r1 = D(r1, s0_0_2, 0x04EB06F7, 0xFEFD09FF, 0xFB030804, 0x010C0AFE);
	r2 = D(r2, s0_0_2, 0x08EEFB18, 0x010B0700, 0xFB1104F4, 0x03FF0800);
	r3 = D(r3, s0_0_2, 0xFA0DABF6, 0x02020002, 0xFB0102F9, 0x02020302);
	r0 = D(r0, s0_1_0, 0x32F30AF8, 0xF703FDF3, 0x0BFBFEF9, 0xFFF608F8);
	r1 = D(r1, s0_1_0, 0x07EE0400, 0xF50207FC, 0x0306F1E7, 0x18F50501);
	r2 = D(r2, s0_1_0, 0x09E8070B, 0x0AFFF6F2, 0xEE0CFCFB, 0x0109E8F9);
	r3 = D(r3, s0_1_0, 0xFF04F1CB, 0xF30D0BF8, 0xF9FDFBF9, 0x01FEFFFE);
	r0 = D(r0, s0_1_1, 0x29ECB4BC, 0x0FEE14E8, 0x2B2324C1, 0x0317FBF9);
	r1 = D(r1, s0_1_1, 0xFB29D6DA, 0xF00A0FF4, 0x0FCEB4D0, 0x4536FAFB);
	r2 = D(r2, s0_1_1, 0x0004F2FF, 0x07E816E7, 0x14F605F4, 0xFB0F17D8);
	r3 = D(r3, s0_1_1, 0xD5C832BC, 0xFB05F410, 0xFEF100FB, 0x0F3B2E03);
	r0 = D(r0, s0_1_2, 0x04E3DBF5, 0xFE1908F9, 0x08F2F4F4, 0xF705FD02);
	r1 = D(r1, s0_1_2, 0x02070CDC, 0xFEF402FF, 0xF9FEEFE5, 0xFDF81402);
	r2 = D(r2, s0_1_2, 0x07FA15EC, 0xFEE60AEF, 0xFAF411F2, 0xFDFFFB00);
	r3 = D(r3, s0_1_2, 0x0515D118, 0xFB0BFF04, 0xFE040202, 0x03FE13F5);
	r0 = D(r0, s0_2_0, 0x09F5F001, 0x0021FFF3, 0x0809F800, 0x0915F2F5);
	r1 = D(r1, s0_2_0, 0xFD000300, 0xFE0400FD, 0x18E510F8, 0xFD0102FF);
	r2 = D(r2, s0_2_0, 0x02EF1AEE, 0xF00FFCFC, 0x0110FE02, 0x0203FBFE);
	r3 = D(r3, s0_2_0, 0x0A0FF30D, 0x13FB18E5, 0x08FF05FE, 0x090802FE);
	r0 = D(r0, s0_2_1, 0x26F81607, 0x08D810EF, 0x2DE3F6F6, 0x20DA04E6);
	r1 = D(r1, s0_2_1, 0x03FD01FB, 0xF90100FE, 0x14F4E8FA, 0xE903FDFE);
	r2 = D(r2, s0_2_1, 0xF4FCF8EE, 0x15120AF4, 0xFB0C08F7, 0x02FEFD00);
	r3 = D(r3, s0_2_1, 0xF82F02FB, 0xF9EEFA19, 0xFE00F902, 0xF7F4F402);
	r0 = D(r0, s0_2_2, 0xFE0CEBFD, 0xF6FCFBF8, 0x0B0300F6, 0x01FFF806);
	r1 = D(r1, s0_2_2, 0xFD0308EF, 0xFEFCFFFE, 0x08F2FD07, 0xFFFF01FF);
	r2 = D(r2, s0_2_2, 0xFEF9E604, 0x0D0605F9, 0xFAFFFDF7, 0x00000201);
	r3 = D(r3, s0_2_2, 0xFB04D409, 0x06FD06FD, 0x030606FF, 0x060706FD);
	r0 = D(r0, s1_0_0, 0xFBFDF1FD, 0x06030301, 0x040A0E0A, 0x0108FF04);
	r1 = D(r1, s1_0_0, 0x0206F905, 0xFD071BFE, 0x170A0411, 0x03030701);
	r2 = D(r2, s1_0_0, 0xFDF7FD18, 0x01F900FF, 0x05FA05FB, 0x38FF39B3);
	r3 = D(r3, s1_0_0, 0xF5EE101A, 0x0BFCFF08, 0xFAE10737, 0xFE0203FF);
	r0 = D(r0, s1_0_1, 0x130CE413, 0x00F708FB, 0x121CF812, 0xF90AFF04);
	r1 = D(r1, s1_0_1, 0x0D0112E5, 0x173D0208, 0x11F1FCF5, 0x0708FC07);
	r2 = D(r2, s1_0_1, 0xED08DAD8, 0x1108F80E, 0x060A1003, 0x0CFAF30D);
	r3 = D(r3, s1_0_1, 0x0FE81AF1, 0x04F8FC04, 0x14180DDA, 0x0703FC00);
	r0 = D(r0, s1_0_2, 0x0102FF14, 0x04FFFF00, 0x0303FEFF, 0xF5FEFEFF);
	r1 = D(r1, s1_0_2, 0x10F5FF09, 0xFCFF06FB, 0x050BF9FD, 0xFD020501);
	r2 = D(r2, s1_0_2, 0xEDF000FE, 0x0905FF03, 0xFBFC0204, 0xFA0605F9);
	r3 = D(r3, s1_0_2, 0xFCFC02FF, 0x020203FE, 0x03F6FA0A, 0x0301FD02);
	r0 = D(r0, s1_1_0, 0xF31842F9, 0x2B0014EC, 0x05FEFE0F, 0x09101F0D);
	r1 = D(r1, s1_1_0, 0xFAFF1206, 0xFFFC01FC, 0xFC0CF3FD, 0xFE020B02);
	r2 = D(r2, s1_1_0, 0xF4E6E707, 0xFA0DF41B, 0x07EFEBF8, 0x17F72314);
	r3 = D(r3, s1_1_0, 0x09F5CFF4, 0x1532FDF9, 0x0C03FEF4, 0x07FAF7FD);
	r0 = D(r0, s1_1_1, 0xCBF4FEF5, 0xE9070AF1, 0x05FF1CD6, 0x1B14F213);
	r1 = D(r1, s1_1_1, 0x3EF84CEA, 0xF21713F6, 0xF10D105F, 0xFE03FDF7);
	r2 = D(r2, s1_1_1, 0xF403EE05, 0x0805120D, 0xFF1C6F05, 0xFEFDFFFB);
	r3 = D(r3, s1_1_1, 0xB806F505, 0xFCF1F705, 0x08F801FE, 0xF4CF3AF9);
	r0 = D(r0, s1_1_2, 0xE1EDF30A, 0x030204FC, 0xFAF3F026, 0x05030006);
	r1 = D(r1, s1_1_2, 0xF805F8FD, 0x07FFFDF5, 0xF4E4FC25, 0x02030CFE);
	r2 = D(r2, s1_1_2, 0xFB02DEF7, 0xF9FBFD16, 0xFDF40CFA, 0xFF010103);
	r3 = D(r3, s1_1_2, 0x0C070E10, 0xFC02FE05, 0x00FCFF01, 0x0506FE06);
	r0 = D(r0, s1_2_0, 0x12FBF3F8, 0x06FE0400, 0x09F8F401, 0x11F8E503);
	r1 = D(r1, s1_2_0, 0xFEFBF3FF, 0x02000102, 0xF7FAFBF8, 0x00000201);
	r2 = D(r2, s1_2_0, 0xF0DFF0FE, 0x05FA0A09, 0x04F90403, 0x080100F9);
	r3 = D(r3, s1_2_0, 0x0DCC0AF1, 0xD3E7F218, 0xFFFE1005, 0x0102FD07);
	r0 = D(r0, s1_2_1, 0x09F9060D, 0x14F41C18, 0x03FDEC0C, 0xFDDF0008);
	r1 = D(r1, s1_2_1, 0x11FE0B04, 0xFF03FFFE, 0xFA0EE7DC, 0x0300F901);
	r2 = D(r2, s1_2_1, 0xF2F30007, 0xFC02F6F8, 0xF9011805, 0x00FEFF05);
	r3 = D(r3, s1_2_1, 0x09EC22F3, 0x121004FE, 0x0402FDF6, 0x11ECFA0C);
	r0 = D(r0, s1_2_2, 0x09FDFD0A, 0x09FD01F8, 0x12F4FD02, 0xFFFEFAFF);
	r1 = D(r1, s1_2_2, 0x0AF90103, 0x030000FD, 0x06FC0204, 0xFE010500);
	r2 = D(r2, s1_2_2, 0xF0F6EF01, 0x0BF9FE05, 0x0F01FFFB, 0xFEFF03FF);
	r3 = D(r3, s1_2_2, 0x0EF50EF7, 0x05F8FD02, 0xFE01FF03, 0x00FFFE03);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFFE414F9, 0xFE0103FF, 0x000102FB, 0x010005FC);
	r1 = D(r1, s0_0_0, 0x00F805F9, 0xFFFD08F8, 0xF7EA07F5, 0xFF020103);
	r2 = D(r2, s0_0_0, 0x040BFBFD, 0xF70BF0FF, 0xFBF9F904, 0x01FD9835);
	r3 = D(r3, s0_0_0, 0x0F0018F2, 0x010303F5, 0x361FB110, 0xFBFCFFFF);
	r0 = D(r0, s0_0_1, 0xF9DBECEA, 0xFD03F504, 0xFEECFDF9, 0xFD0B08FA);
	r1 = D(r1, s0_0_1, 0x020FE014, 0xE91AE81B, 0xE001F001, 0x03FBFE05);
	r2 = D(r2, s0_0_1, 0x0BE1E209, 0xF3F2FFDE, 0xF30705F5, 0x0FF3EE23);
	r3 = D(r3, s0_0_1, 0x0718DD08, 0xF704FFF8, 0x1FF00407, 0xFA03FF04);
	r0 = D(r0, s0_0_2, 0x11FD0117, 0x0D0102FF, 0xFA04FE19, 0xFD04000B);
	r1 = D(r1, s0_0_2, 0x07EFFEF4, 0x18060113, 0xFAFC01CC, 0xFF01FF0B);
	r2 = D(r2, s0_0_2, 0xF1EEF9EF, 0xFCF9FAEE, 0xFE02000F, 0x07070109);
	r3 = D(r3, s0_0_2, 0x25F7071B, 0xFDFDFCFE, 0xED0902F4, 0xFCF9FFFB);
	r0 = D(r0, s0_1_0, 0xE42DEA0F, 0xFEE7E212, 0xF40203EE, 0xEE1FFBFA);
	r1 = D(r1, s0_1_0, 0xFE0607FC, 0xFBFC030E, 0x1AF0DA26, 0xFD010000);
	r2 = D(r2, s0_1_0, 0xF5031106, 0x020A13EE, 0x00FF0203, 0x11E1F2FC);
	r3 = D(r3, s0_1_0, 0x08E9AB09, 0xF5C4F511, 0xF707081B, 0xFCFFFE02);
	r0 = D(r0, s0_1_1, 0x1831D709, 0x152DC0FB, 0xEA34A5EC, 0xF30AD90D);
	r1 = D(r1, s0_1_1, 0x14D7BC03, 0xF7050805, 0x37E9A80D, 0xF3080231);
	r2 = D(r2, s0_1_1, 0x1AFDE9FC, 0x090EB212, 0x0F0A05E5, 0x0E140505);
	r3 = D(r3, s0_1_1, 0x0BED810E, 0xFE100705, 0xEE0600F6, 0x27101D01);
	r0 = D(r0, s0_1_2, 0x0504F1FC, 0x08EDFF27, 0x001AE1D9, 0x1209020C);
	r1 = D(r1, s0_1_2, 0x0813F82B, 0x140304FD, 0xF7F0F326, 0x2101FFF1);
	r2 = D(r2, s0_1_2, 0xF80FFB11, 0xF311E5ED, 0x29FCFA21, 0x010400FC);
	r3 = D(r3, s0_1_2, 0x2CF2FE14, 0x01FE01F2, 0x08FE0106, 0xFC14F912);
	r0 = D(r0, s0_2_0, 0x15EE060E, 0x0DF107F6, 0x0B0304FF, 0x0EECF3E3);
	r1 = D(r1, s0_2_0, 0xFF0206FC, 0xFE00FFFE, 0xF60A0008, 0xFE00FF06);
	r2 = D(r2, s0_2_0, 0xE71FFDFB, 0x01FD01E4, 0x0305FBFD, 0x08FD01FF);
	r3 = D(r3, s0_2_0, 0x0AFCFA0B, 0xF337ABC0, 0xFA0001FC, 0x00010202);
	r0 = D(r0, s0_2_1, 0xF8F7F606, 0x12F6DD21, 0xFAFEFB1C, 0xF9FACC0E);
	r1 = D(r1, s0_2_1, 0x0DF7FC0F, 0xFBFF0302, 0x181912DE, 0x06040302);
	r2 = D(r2, s0_2_1, 0x0AE7FC08, 0xE40513EB, 0xF5FB0015, 0xFE0400FE);
	r3 = D(r3, s0_2_1, 0xF6F5FE1F, 0x1AEBF325, 0x0201FE00, 0x0EFDF512);
	r0 = D(r0, s0_2_2, 0x0802FFEE, 0x081306F1, 0x01F300FF, 0xFF06F9F7);
	r1 = D(r1, s0_2_2, 0x010505F9, 0xFEFFFF05, 0x1804FF00, 0x00FBFF13);
	r2 = D(r2, s0_2_2, 0x000A10EC, 0x03FF12D5, 0x080002F0, 0xFE0000FC);
	r3 = D(r3, s0_2_2, 0xF1070EF5, 0xF60308F7, 0xF7010002, 0xF2F9FE1F);
	r0 = D(r0, s1_0_0, 0x04FE0CFF, 0xF8FCFC02, 0xFFF20606, 0xFDF70503);
	r1 = D(r1, s1_0_0, 0x01FA0402, 0xFAE9F305, 0xF9FCE903, 0xFE010300);
	r2 = D(r2, s1_0_0, 0xFFF5C1FD, 0xF411F8F6, 0xFC09F8FC, 0xD1FCF003);
	r3 = D(r3, s1_0_0, 0x04F31C01, 0x00FFF3FE, 0xFA17E8FB, 0x0001F9FF);
	r0 = D(r0, s1_0_1, 0xF80407FA, 0x0203FD02, 0xF4F60506, 0xFDFB0005);
	r1 = D(r1, s1_0_1, 0xDF03FA02, 0xFB3116F8, 0xDF12F707, 0xFEF90905);
	r2 = D(r2, s1_0_1, 0xF6DFD206, 0xF40BFFF8, 0x03FD05FF, 0x080FFAFC);
	r3 = D(r3, s1_0_1, 0x07F116F4, 0x010FFC00, 0xF1E70EFD, 0xFB0700FF);
	r0 = D(r0, s1_0_2, 0x09F5F715, 0xFF0103FB, 0x00FAFC0E, 0x02FDFF05);
	r1 = D(r1, s1_0_2, 0x070CF7F7, 0xF8EC0808, 0xFB12F2FB, 0x00FF03FF);
	r2 = D(r2, s1_0_2, 0xEDF8D51D, 0xFBFCFBFE, 0xFEFCFD05, 0x00F60802);
	r3 = D(r3, s1_0_2, 0xFCEE1A06, 0xFFFD00FF, 0xFE07FA02, 0x0103FFFC);
	r0 = D(r0, s1_1_0, 0xE3DFCC0A, 0xF900FDFE, 0xF6020AFD, 0xF7FA0C01);
	r1 = D(r1, s1_1_0, 0xFD01F802, 0xFF02F906, 0xDD070BFF, 0xFFFBFA00);
	r2 = D(r2, s1_1_0, 0xFEE6F3FA, 0xF3E12106, 0x081208FC, 0xD205E9E1);
	r3 = D(r3, s1_1_0, 0x19F73FFA, 0xE9F31404, 0x00DEFF04, 0xFE1A04FA);
	r0 = D(r0, s1_1_1, 0xB00906E7, 0x000AF0F7, 0xC90200E3, 0xEDF50A06);
	r1 = D(r1, s1_1_1, 0xC6020DE7, 0x02E6E5EC, 0xF6F01EF0, 0xFE19EAFD);
	r2 = D(r2, s1_1_1, 0xE9E8EBEE, 0xAEE9080C, 0xF6E2EE10, 0x0603F911);
	r3 = D(r3, s1_1_1, 0x01101E17, 0x03F7FBFB, 0xFE03F7F7, 0xF9DB01FB);
	r0 = D(r0, s1_1_2, 0xF920EE1A, 0xFDFB0408, 0xFA1602CF, 0x0001FEF1);
	r1 = D(r1, s1_1_2, 0x04FFF60D, 0x03FA011D, 0xFDEDF529, 0x01F707F7);
	r2 = D(r2, s1_1_2, 0xF5F7F4F6, 0xFA0A03F0, 0xFEFD05E7, 0xFFFB02FD);
	r3 = D(r3, s1_1_2, 0x08E632FC, 0x0606FF04, 0x0702FEFF, 0x0210010B);
	r0 = D(r0, s1_2_0, 0xF405EE2E, 0xE904F1E7, 0xF403080B, 0xE708020D);
	r1 = D(r1, s1_2_0, 0x05FEFC01, 0xFE03FDFD, 0xFFE9F10F, 0x0004FFFB);
	r2 = D(r2, s1_2_0, 0x0B02D409, 0xFEFE0F0A, 0xFD05FF01, 0x01FD0609);
	r3 = D(r3, s1_2_0, 0x0CED290E, 0xE00E12DF, 0x0C0306FE, 0xFF02FCF9);
	r0 = D(r0, s1_2_1, 0xE7FF0C2A, 0x0507EC17, 0xC800FB11, 0xE51D000C);
	r1 = D(r1, s1_2_1, 0xECFBF708, 0x01FF0105, 0xF2F71314, 0xFFF90EFF);
	r2 = D(r2, s1_2_1, 0xFFD2F0F4, 0x02FEEBF9, 0x07F9EDF9, 0x0201FFF5);
	r3 = D(r3, s1_2_1, 0x0BCE2BFA, 0xFCF6EEED, 0xFBFC0100, 0xF51F1805);
	r0 = D(r0, s1_2_2, 0xFD02F70B, 0x000100E2, 0xED040021, 0xFB07FC0B);
	r1 = D(r1, s1_2_2, 0x0508FCDF, 0x020001FF, 0x08F4FD14, 0x010201FA);
	r2 = D(r2, s1_2_2, 0xEEE1E6EB, 0xFAF906DF, 0x04FE070C, 0x00020102);
	r3 = D(r3, s1_2_2, 0xFDED101B, 0xFD020103, 0x00020002, 0xFC0AFAF9);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-2.960e-02, -1.441e-02, -1.345e-02, -1.898e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-8.563e-03, -2.328e-02, -2.472e-02, -7.655e-04);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-5.918e-02, -1.616e-02, -3.839e-03, -1.180e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-1.685e-01, -2.208e-02, -1.794e-03, 1.773e-03);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-6x16-BILINEAR-MPV-NVL-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv6
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_spirv_intrinsics : require
spirv_instruction (extensions = ["SPV_KHR_integer_dot_product"], capabilities = [6019, 6018], id = 4450)
int dp4(int a, int b, spirv_literal int fmt);
#define D(r, s, a, b, c, d) r + ivec4(dp4(s, a, 0), dp4(s, b, 0), dp4(s, c, 0), dp4(s, d, 0))
shared int G[4][10][10];
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
			vec2 p;
			vec4 r, g, b, a;
			p = vec2(clamp(pos + ivec2(x - 1, y - 1), ivec2(0), sz) * ivec2(2, 2) + ivec2(1, 1)) * conv6_pt;
			r = conv6_gather(p, 0);
			g = conv6_gather(p, 1);
			b = conv6_gather(p, 2);
			a = conv6_gather(p, 3);
			vec4 v0 = vec4(r.w, g.w, b.w, a.w) * 1.0000000e+00;
			vec4 v1 = vec4(r.z, g.z, b.z, a.z) * 1.0000000e+00;
			vec4 v2 = vec4(r.x, g.x, b.x, a.x) * 1.0000000e+00;
			vec4 v3 = vec4(r.y, g.y, b.y, a.y) * 1.0000000e+00;
			G[0][ay][ax] = int(packSnorm4x8(v0));
			G[1][ay][ax] = int(packSnorm4x8(v1));
			G[2][ay][ax] = int(packSnorm4x8(v2));
			G[3][ay][ax] = int(packSnorm4x8(v3));
		}
	}
	barrier();
	int s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	ivec4 r0;
	vec4 f0;
	r0 = ivec4(0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x02020300, 0x00FEFF01, 0x0002FF01, 0x020200FF);
	r0 = D(r0, s0_0_1, 0xD905EAFF, 0xEF090C01, 0xFF010501, 0xFD01FF01);
	r0 = D(r0, s0_0_2, 0x010000FF, 0xEC0201FA, 0x00000000, 0x0001FE01);
	r0 = D(r0, s0_1_0, 0xFD1102FC, 0x00000002, 0x03E906FD, 0x0002FEFF);
	r0 = D(r0, s0_1_1, 0x070FF424, 0x00260605, 0x21EDC5E2, 0x17C818EF);
	r0 = D(r0, s0_1_2, 0xFE0201FF, 0x03010316, 0x02FE0403, 0x0F0209F8);
	r0 = D(r0, s0_2_0, 0x0000FF00, 0x00000001, 0x01020103, 0x000200FF);
	r0 = D(r0, s0_2_1, 0xFFFE00FB, 0x00FE00FB, 0x00020404, 0x0101040C);
	r0 = D(r0, s0_2_2, 0x00000000, 0xFF0002FE, 0x000200FD, 0xFF0400FB);
	r0 = D(r0, s1_0_0, 0xFCFE00FE, 0xFF0001FF, 0xFFFF0001, 0xFF000000);
	r0 = D(r0, s1_0_1, 0x00040009, 0xFBFDFF04, 0xFFFC0002, 0x00FD01FC);
	r0 = D(r0, s1_0_2, 0x00FF0000, 0x0205FF01, 0x00000000, 0xFFFE0001);
	r0 = D(r0, s1_1_0, 0x0305020B, 0xFC02FF06, 0xFB060003, 0xFE000101);
	r0 = D(r0, s1_1_1, 0x24D40529, 0x20E508B2, 0x0E1FFF14, 0x021DFEED);
	r0 = D(r0, s1_1_2, 0x000000FD, 0x0AF10108, 0x00FE00FE, 0x0706FF04);
	r0 = D(r0, s1_2_0, 0xFB010501, 0x01FFFFFF, 0x02F908FE, 0xFE00FEFF);
	r0 = D(r0, s1_2_1, 0xF7041301, 0xF1031104, 0x0504180D, 0x0AFB1BF7);
	r0 = D(r0, s1_2_2, 0x0100FF00, 0xFD020600, 0x0000FFFF, 0x04030605);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x000108E7, 0x0000FF13, 0x00FEFFEE, 0x0001000D);
	r0 = D(r0, s0_0_1, 0x02FB040C, 0x00090EF4, 0x00FFFBF3, 0xFFFDFC0A);
	r0 = D(r0, s0_0_2, 0x0100FD05, 0xFCFDFC0A, 0x0000FF0A, 0x0001FEFC);
	r0 = D(r0, s0_1_0, 0xFF0CF7FF, 0x01FA0209, 0x010CFA06, 0x00FBFD0F);
	r0 = D(r0, s0_1_1, 0x08DED323, 0xFC1ED716, 0xFFEB30EF, 0x002316EE);
	r0 = D(r0, s0_1_2, 0x0300091B, 0xFBF7FA0C, 0xFE00012C, 0x05F613F3);
	r0 = D(r0, s0_2_0, 0x000000F3, 0x0003FFF7, 0xFE0201FA, 0x0101FE06);
	r0 = D(r0, s0_2_1, 0x010205FA, 0xFEFD02F1, 0x19F5FBE6, 0xFD0306F1);
	r0 = D(r0, s0_2_2, 0x0500011E, 0x020004FF, 0x1E00FBE5, 0xC6FCF512);
	r0 = D(r0, s1_0_0, 0xFD000100, 0x01000000, 0x0100FF00, 0x010000FF);
	r0 = D(r0, s1_0_1, 0xF700FEFD, 0xF5000000, 0x02000EFF, 0x0200FD00);
	r0 = D(r0, s1_0_2, 0x00FF1EFE, 0xFF0010FB, 0xFF00E201, 0xFF010701);
	r0 = D(r0, s1_1_0, 0xFA0000FD, 0x01000000, 0xF700FF02, 0x03000001);
	r0 = D(r0, s1_1_1, 0xE9FF00DC, 0xE90000E3, 0xE401FEE6, 0xDFFF00F4);
	r0 = D(r0, s1_1_2, 0x0009FDFD, 0xF9FE00ED, 0x02F905FB, 0xFB00FDEF);
	r0 = D(r0, s1_2_0, 0x02000000, 0x01000000, 0x010000FA, 0x00000001);
	r0 = D(r0, s1_2_1, 0x030300FC, 0x02FD00FD, 0xFC00FFEB, 0xFEFF00ED);
	r0 = D(r0, s1_2_2, 0x00E000FF, 0x031900FD, 0x0004FF00, 0xFD0CFFFA);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-8.450e-04, -6.843e-04, -6.032e-04, -6.898e-04);
	f0 = tanh(f0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(f0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(f0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(f0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(f0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
