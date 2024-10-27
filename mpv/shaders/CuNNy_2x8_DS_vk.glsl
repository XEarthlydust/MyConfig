// CuNNy 2x8 BILINEAR MPV NVL
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


//!DESC CuNNy-2x8-BILINEAR-MPV-NVL-in
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
	r0 += V4(-4.160e-04, -7.890e-03, -1.460e-01, 3.159e-03) * s0_0_0;
	r1 += V4(-1.668e-02, 8.807e-02, 6.762e-03, 3.238e-01) * s0_0_0;
	r0 += V4(-2.800e-02, -9.773e-02, 1.823e-02, -1.567e-01) * s0_0_1;
	r1 += V4(5.529e-02, -6.092e-02, -1.328e-01, 2.190e-01) * s0_0_1;
	r0 += V4(2.489e-02, 4.962e-02, -9.583e-02, -2.952e-02) * s0_0_2;
	r1 += V4(8.069e-03, -3.029e-02, 1.432e-01, -7.208e-03) * s0_0_2;
	r0 += V4(6.822e-01, 1.962e-02, -2.929e-01, -6.375e-02) * s0_1_0;
	r1 += V4(1.229e-02, -6.038e-01, 1.049e-01, -1.178e-01) * s0_1_0;
	r0 += V4(-6.699e-01, -1.286e-01, 1.004e+00, 8.430e-01) * s0_1_1;
	r1 += V4(-2.114e-01, -1.463e-01, -4.813e-01, -8.995e-02) * s0_1_1;
	r0 += V4(-5.696e-03, -4.178e-01, -1.287e-01, -1.536e-01) * s0_1_2;
	r1 += V4(-6.059e-02, 1.033e-01, -3.210e-01, 9.043e-02) * s0_1_2;
	r0 += V4(1.357e-02, 3.665e-02, 3.641e-03, -5.285e-02) * s0_2_0;
	r1 += V4(3.964e-02, 1.147e-01, -9.482e-02, 3.061e-02) * s0_2_0;
	r0 += V4(4.122e-03, -1.890e-01, -2.073e-01, 1.989e-01) * s0_2_1;
	r1 += V4(2.166e-01, 6.113e-01, 6.327e-01, -1.232e-01) * s0_2_1;
	r0 += V4(-1.592e-02, 8.184e-02, -6.696e-02, 1.315e-02) * s0_2_2;
	r1 += V4(1.333e-01, -7.482e-02, 1.519e-01, 8.667e-02) * s0_2_2;
	r0 += V4(-3.883e-03, 6.835e-01, -1.713e-02, 1.208e-01);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(3.009e-02, -4.317e-03, 3.969e-03, 1.465e-02);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-2x8-BILINEAR-MPV-NVL-conv1
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
	r0 = D(r0, s0_0_0, 0xDA1112DC, 0xF404E015, 0xCF09171F, 0xF4FC0C08);
	r1 = D(r1, s0_0_0, 0xF40B0BF3, 0xFD040000, 0x04F812EE, 0xF531F20D);
	r0 = D(r0, s0_0_1, 0xE122F7E0, 0xF6068126, 0xE727062E, 0x01010E28);
	r1 = D(r1, s0_0_1, 0x0EFCF113, 0x0A1517ED, 0x0D17E4E4, 0x866F34BD);
	r0 = D(r0, s0_0_2, 0xE0170109, 0x2E06A643, 0x0706E804, 0x17F8E435);
	r1 = D(r1, s0_0_2, 0xFC0207F0, 0x17F3F5E6, 0xDB0B1705, 0xE82C01EB);
	r0 = D(r0, s0_1_0, 0xF50118E4, 0x0EDF0108, 0x220223E8, 0xE005FDFF);
	r1 = D(r1, s0_1_0, 0x23031CF0, 0xCD1102F7, 0xFDF9EDED, 0x81F43508);
	r0 = D(r0, s0_1_1, 0x1DA0D62A, 0xF8DF8117, 0xC3A7F9AB, 0xD1CBEC34);
	r1 = D(r1, s0_1_1, 0x08C1E43A, 0x2A24EDBD, 0x40CBF522, 0x81D1207F);
	r0 = D(r0, s0_1_2, 0x28FA037F, 0x587FAC7F, 0x03260C1B, 0x5D0BFD7D);
	r1 = D(r1, s0_1_2, 0x04F4FB0D, 0x28EC0106, 0x0AEFFC71, 0xFC41087F);
	r0 = D(r0, s0_2_0, 0x1003E60C, 0xE7F813FF, 0x522EE9EC, 0xF61407F3);
	r1 = D(r1, s0_2_0, 0xF008D6EE, 0xE7EE11F1, 0xF00002FF, 0xED2500FE);
	r0 = D(r0, s0_2_1, 0x060D1AD1, 0xE1D3D53F, 0x3F35F181, 0xDDCAFD0D);
	r1 = D(r1, s0_2_1, 0x10E62822, 0xBD8E1022, 0xB7DF110F, 0xB3E91D09);
	r0 = D(r0, s0_2_2, 0xDC12FEA6, 0xFBFFED26, 0xDAF20C0C, 0x1715FD51);
	r1 = D(r1, s0_2_2, 0xFAF8FB28, 0x0314F675, 0xE808020A, 0xA60A083A);
	r0 = D(r0, s1_0_0, 0x0FE62B15, 0xFF1511F9, 0x0D282115, 0x0901E81F);
	r1 = D(r1, s1_0_0, 0x0410FA07, 0x010BEA12, 0xFDCB0EF6, 0xF717158A);
	r0 = D(r0, s1_0_1, 0xE11D2DE9, 0xEF37FE0A, 0x0B43E5F0, 0xECF8D1F0);
	r1 = D(r1, s1_0_1, 0x031E10CD, 0x0AF4DD35, 0x01EA39CD, 0x176C7F81);
	r0 = D(r0, s1_0_2, 0x041F4801, 0xF8465617, 0xD905BC1E, 0x01F40325);
	r1 = D(r1, s1_0_2, 0xF9F7E5FF, 0x05F7CD34, 0x070D23FC, 0xF208FFE2);
	r0 = D(r0, s1_1_0, 0x44D1120F, 0xF20817FB, 0xFE819D04, 0xE1E9EFE0);
	r1 = D(r1, s1_1_0, 0x0206EE0F, 0xEC052110, 0x0FE11A26, 0xF71A0CE0);
	r0 = D(r0, s1_1_1, 0x041D35DF, 0x13EA0A0F, 0x293481EE, 0xD832F60D);
	r1 = D(r1, s1_1_1, 0x1344410C, 0xEB2618CA, 0x074D29F2, 0x29633A3E);
	r0 = D(r0, s1_1_2, 0x47EA1CF1, 0x022A3F06, 0x0C22F1F5, 0x13E5FA24);
	r1 = D(r1, s1_1_2, 0xE221150D, 0xCFE9CDEE, 0x100E0BBC, 0xCAE37F10);
	r0 = D(r0, s1_2_0, 0x2ED2FB05, 0x13170B06, 0xD1C6ECF1, 0xE3E8F611);
	r1 = D(r1, s1_2_0, 0xE916EDE5, 0x1A050212, 0x1EE709FD, 0xE60415CE);
	r0 = D(r0, s1_2_1, 0xD6D507F2, 0xFEF4F9E3, 0xE1C6CE14, 0xCFF7EB1C);
	r1 = D(r1, s1_2_1, 0xED1BFDF2, 0x542011DF, 0x24F51B39, 0xD11D16EC);
	r0 = D(r0, s1_2_2, 0xBEC62840, 0x2F1C1DEB, 0x19153108, 0x440013DF);
	r1 = D(r1, s1_2_2, 0x0AFF00FA, 0x3113ECCE, 0x10E81110, 0x331C22E9);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(7.007e-02, -3.081e-01, -8.560e-02, 1.038e-01);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-4.808e-03, -1.209e-01, 2.080e-02, -1.096e-01);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-2x8-BILINEAR-MPV-NVL-conv2
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
	r0 = D(r0, s0_0_0, 0xF9F0300A, 0xE4E0FF1C, 0x00FC0002, 0x13FA06F7);
	r1 = D(r1, s0_0_0, 0x45FD31C4, 0x0A032C0F, 0x150742EE, 0x06FA810A);
	r0 = D(r0, s0_0_1, 0xDCF10F14, 0x24EB10F2, 0x0AF813F7, 0xF9FE0F0D);
	r1 = D(r1, s0_0_1, 0xB8F82E35, 0xEFD42110, 0xF9EE3510, 0x470F16CB);
	r0 = D(r0, s0_0_2, 0x22DE05F5, 0xFBD70907, 0x01ED0902, 0x03F206FC);
	r1 = D(r1, s0_0_2, 0x09F402F2, 0xFBE41002, 0x04F311FD, 0xD2940F21);
	r0 = D(r0, s0_1_0, 0xDE0AA5E8, 0x21E481D2, 0xF00281FC, 0x0BFBCBDC);
	r1 = D(r1, s0_1_0, 0x03F94405, 0xD8DF8EC7, 0x0EFB7FFB, 0x1FFA3DE9);
	r0 = D(r0, s0_1_1, 0x1CBF2C9E, 0xD8CE3140, 0x1DEFFEFE, 0x19EB0F03);
	r1 = D(r1, s0_1_1, 0xF8FE18F1, 0x1A9FCCF4, 0x0D06520F, 0xC20C81FB);
	r0 = D(r0, s0_1_2, 0xD49A0ED9, 0x0BD303D8, 0xF8EE060A, 0x01F303FC);
	r1 = D(r1, s0_1_2, 0xFFFAF8FC, 0xF4BC0930, 0x04F810F1, 0x2FF149CE);
	r0 = D(r0, s0_2_0, 0x100A12FA, 0xFFF536FF, 0x000304FE, 0x0B00E405);
	r1 = D(r1, s0_2_0, 0x04FEFBFF, 0xEFE9F921, 0xFAFB1602, 0xF1F917F7);
	r0 = D(r0, s0_2_1, 0xEC11E50A, 0xF6E00E0F, 0xFF0313FE, 0x07F70D06);
	r1 = D(r1, s0_2_1, 0xF902F5FA, 0xCFE72F0B, 0x010200FE, 0x19030CFE);
	r0 = D(r0, s0_2_2, 0x08050506, 0xFAEEF803, 0x02FF06FD, 0xFDFA0AFC);
	r1 = D(r1, s0_2_2, 0xFF05FBFF, 0x01D710FC, 0x000001FB, 0xFDFC0AE1);
	r0 = D(r0, s1_0_0, 0x01F72DF4, 0xFFEBF1EB, 0xFFFE0BFC, 0x070D1707);
	r1 = D(r1, s1_0_0, 0x2931D51C, 0x07ECF502, 0x0504F005, 0xECFA06EA);
	r0 = D(r0, s1_0_1, 0xEEDE140B, 0x011AF000, 0x15141D09, 0x0D041DFA);
	r1 = D(r1, s1_0_1, 0xE8CF2DF6, 0xFEED0ED4, 0xF9F33B1F, 0x1512D344);
	r0 = D(r0, s1_0_2, 0x0CF5F839, 0x0BFDEA0B, 0x08030702, 0x04040406);
	r1 = D(r1, s1_0_2, 0x00060C07, 0x060405EE, 0x0904000E, 0x12E722E0);
	r0 = D(r0, s1_1_0, 0x0EF4E624, 0x0F38E0E1, 0x0E0C0102, 0x4A32DE1F);
	r1 = D(r1, s1_1_0, 0x1B0AF40B, 0x122EFBF1, 0x0DFCFE07, 0x03E10711);
	r0 = D(r0, s1_1_1, 0x1420E051, 0x15AE1927, 0x4FF8E42B, 0x51E20800);
	r1 = D(r1, s1_1_1, 0xE8F60AE7, 0x1249D83E, 0xDC26F7E5, 0xFD1FDDF6);
	r0 = D(r0, s1_1_2, 0xFD1C2BD7, 0xF01ADFDC, 0x0BF60A01, 0x0503040C);
	r1 = D(r1, s1_1_2, 0x07EEFD16, 0x11E5F7FF, 0xF703FE0F, 0x11DEFC20);
	r0 = D(r0, s1_2_0, 0x08E407E7, 0x0A31DD04, 0x0200FDFC, 0x2100FE03);
	r1 = D(r1, s1_2_0, 0x01F701FF, 0x0BDE0AFA, 0x00F602FC, 0x03F30200);
	r0 = D(r0, s1_2_1, 0x12CD21DE, 0x06FC02E1, 0x0EF802FA, 0x25F4FE0A);
	r1 = D(r1, s1_2_1, 0xFF0BFF05, 0x14DB1FD3, 0x0001FF02, 0xF9FFEDFF);
	r0 = D(r0, s1_2_2, 0x13E7060F, 0x0603FC08, 0xFC06FCFE, 0x000002FF);
	r1 = D(r1, s1_2_2, 0x00F106FC, 0xF61FF405, 0x01FEFF02, 0x02F00DFF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-7.493e-03, 1.961e-04, 3.049e-03, 1.065e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-8.395e-04, -2.982e-04, 5.312e-03, -1.448e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
}

//!DESC CuNNy-2x8-BILINEAR-MPV-NVL-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv2
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
#define l0(x, y) V4(conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv2_pt))
#define l1(x, y) V4(conv2_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv2_pt))
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
	r0 += M4(-2.783e-01, -8.255e-03, 9.206e-02, 4.604e-02, -6.098e-03, -1.320e-02, -7.784e-03, 3.415e-03, 1.230e-01, 1.072e-01, -1.162e-01, -2.069e-02, 5.432e-02, -4.117e-02, 5.847e-02, -1.235e-02) * s0_0_0;
	r0 += M4(4.923e-02, -3.740e-01, 1.606e-01, 1.686e-01, -6.269e-02, 2.065e-01, 1.075e-01, -2.078e-02, 2.904e-01, 5.679e-02, -4.930e-02, -1.701e-01, -4.569e-01, -2.021e-02, 7.011e-02, 1.365e-01) * s0_0_1;
	r0 += M4(4.455e-02, 1.411e-01, -4.457e-02, -1.861e-02, 2.418e-01, -3.353e-01, 8.759e-02, -7.444e-02, -2.399e-02, 1.484e-01, -8.569e-02, -6.708e-02, 8.891e-02, -1.958e-01, 1.041e-01, 1.103e-01) * s0_0_2;
	r0 += M4(8.423e-02, -4.180e-02, 9.202e-02, 2.559e-02, 1.030e-01, -2.074e-02, 7.642e-02, -5.479e-02, -1.413e-01, 4.676e-02, 2.001e-01, 1.755e-01, 5.068e-02, -1.205e-02, 2.984e-02, -4.826e-02) * s0_1_0;
	r0 += M4(2.906e-01, 4.151e-01, -4.768e-01, -1.276e-01, -3.996e-01, 1.673e-01, -5.106e-01, 4.561e-01, -3.965e-01, -8.162e-01, 7.403e-02, -3.847e-01, -1.267e-01, 1.592e-01, -7.958e-01, -5.292e-02) * s0_1_1;
	r0 += M4(-5.018e-02, -3.599e-02, 9.507e-02, -2.076e-01, 5.787e-03, 1.415e-01, 2.116e-01, -1.655e-01, -2.156e-01, 5.642e-02, -5.674e-02, 3.318e-01, 1.870e-01, -4.525e-02, 7.249e-02, -5.062e-01) * s0_1_2;
	r0 += M4(5.745e-03, -8.435e-03, -2.006e-02, -1.225e-02, -2.899e-02, -1.622e-02, 2.451e-03, 6.230e-03, 1.573e-02, 7.917e-03, 4.691e-02, 3.422e-02, 4.182e-03, -2.942e-03, 7.502e-03, -2.558e-03) * s0_2_0;
	r0 += M4(-5.019e-02, -6.027e-03, 4.829e-02, -2.838e-02, 7.580e-02, -2.309e-02, 1.586e-02, -9.219e-02, 1.126e-01, 2.120e-02, 1.792e-01, 4.680e-02, -3.359e-02, 5.673e-03, 2.743e-02, 3.591e-02) * s0_2_1;
	r0 += M4(-2.622e-02, -4.333e-02, 1.177e-02, 8.166e-02, -1.851e-02, 1.577e-03, -5.749e-02, 8.435e-02, -5.914e-02, 4.258e-02, -7.590e-02, 9.158e-02, 1.743e-02, -1.327e-02, 3.771e-02, 3.915e-02) * s0_2_2;
	r0 += M4(-6.176e-03, 8.148e-03, -1.524e-02, -2.906e-03, 1.673e-01, 1.679e-02, -2.199e-02, -2.936e-02, -5.601e-03, -1.415e-02, 3.243e-03, -3.961e-03, 5.080e-02, 1.087e-02, -8.700e-03, -5.551e-03) * s1_0_0;
	r0 += M4(4.583e-03, -1.018e-02, 9.950e-03, -6.253e-03, -3.135e-01, 1.321e-01, 2.007e-01, 1.233e-01, -2.389e-02, -4.768e-03, -1.582e-02, -7.284e-03, -4.636e-02, 5.486e-02, -2.375e-02, -4.163e-02) * s1_0_1;
	r0 += M4(-2.129e-02, 3.304e-02, 6.206e-03, 9.308e-03, 6.931e-03, -2.861e-01, 3.009e-02, 1.362e-01, -3.408e-03, -8.707e-03, 1.767e-03, 5.036e-04, -2.629e-03, -4.502e-03, 4.650e-03, 2.073e-05) * s1_0_2;
	r0 += M4(-1.174e-01, 3.630e-02, -7.635e-02, 2.531e-02, -1.019e-01, -1.064e-02, -1.107e-01, 1.027e-01, 2.531e-01, -2.631e-02, 1.432e-01, -2.715e-02, -4.619e-01, 2.529e-01, -1.978e-01, 9.985e-02) * s1_1_0;
	r0 += M4(3.847e-01, -2.311e-01, 4.042e-02, -1.479e-01, 4.600e-01, 1.804e-01, -2.944e-01, -4.756e-01, 2.210e-01, 5.801e-01, 1.255e-01, 3.089e-01, 2.278e-01, -1.627e-01, 4.998e-03, 2.302e-01) * s1_1_1;
	r0 += M4(-8.471e-02, -1.132e-02, -4.757e-02, 6.930e-02, -2.090e-02, 1.067e-01, 7.593e-02, 2.210e-02, 6.880e-03, 5.268e-03, -1.137e-02, -2.593e-02, 5.074e-04, -2.055e-02, 2.258e-02, 5.752e-03) * s1_1_2;
	r0 += M4(-3.465e-02, 5.902e-03, -5.020e-02, 4.044e-02, -3.343e-02, -2.580e-02, 6.362e-02, -2.371e-03, -2.961e-02, 7.675e-03, 4.794e-02, -1.946e-02, 1.298e-01, -2.368e-02, -9.203e-02, 9.990e-02) * s1_2_0;
	r0 += M4(1.163e-01, -9.298e-02, 4.482e-01, -1.515e-01, -2.866e-02, -3.918e-02, 1.137e-02, 5.370e-02, -7.110e-03, -1.387e-02, 5.676e-02, 2.283e-01, 3.966e-02, -1.267e-01, 2.842e-01, -3.688e-01) * s1_2_1;
	r0 += M4(-2.559e-02, 9.333e-02, -8.865e-02, -1.481e-02, 4.341e-03, -1.071e-02, -2.689e-03, -4.093e-02, 1.553e-02, -1.233e-02, 1.776e-02, -2.065e-03, -3.210e-02, 4.662e-02, -4.213e-02, 1.747e-03) * s1_2_2;
	r0 += V4(-2.717e-08, -1.945e-08, -2.852e-08, -1.930e-08);
	r0 = tanh(r0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
