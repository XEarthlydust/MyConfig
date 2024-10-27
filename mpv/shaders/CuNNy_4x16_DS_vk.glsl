// CuNNy 4x16 BILINEAR MPV NVL
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


//!DESC CuNNy-4x16-BILINEAR-MPV-NVL-in
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
	r0 += V4(-5.373e-02, 1.606e-02, 2.588e-01, 1.941e-03) * s0_0_0;
	r1 += V4(2.110e-03, -4.326e-01, 2.896e-03, -1.585e-02) * s0_0_0;
	r2 += V4(2.349e-01, 1.197e-02, 2.688e-02, -9.564e-03) * s0_0_0;
	r3 += V4(-6.017e-02, -1.086e-01, -2.776e-02, -3.818e-02) * s0_0_0;
	r0 += V4(2.881e-01, -3.942e-02, 1.795e-01, -1.156e-02) * s0_0_1;
	r1 += V4(4.757e-01, -9.607e-02, -4.706e-02, 6.141e-02) * s0_0_1;
	r2 += V4(3.135e-01, -1.052e-01, -1.379e-02, 2.058e-02) * s0_0_1;
	r3 += V4(-4.887e-01, -8.813e-02, -2.634e-02, -1.284e-01) * s0_0_1;
	r0 += V4(-2.771e-01, 1.629e-02, 1.874e-02, 3.017e-03) * s0_0_2;
	r1 += V4(3.094e-02, -4.808e-03, 4.553e-02, -6.731e-02) * s0_0_2;
	r2 += V4(2.327e-02, 8.961e-02, -1.867e-03, 6.410e-02) * s0_0_2;
	r3 += V4(-2.703e-02, 2.032e-01, -2.078e-02, 6.752e-02) * s0_0_2;
	r0 += V4(4.683e-02, -2.826e-02, 1.969e-01, 2.095e-01) * s0_1_0;
	r1 += V4(-1.191e-01, 1.335e-02, 8.179e-02, 1.910e-01) * s0_1_0;
	r2 += V4(6.467e-02, 3.614e-01, -1.437e-01, 2.695e-02) * s0_1_0;
	r3 += V4(7.506e-02, 3.534e-01, 3.628e-02, -3.599e-02) * s0_1_0;
	r0 += V4(2.902e-01, 3.372e-02, -1.801e-01, 2.577e-01) * s0_1_1;
	r1 += V4(-3.896e-01, 5.131e-03, -3.319e-01, 1.478e-01) * s0_1_1;
	r2 += V4(-5.527e-01, -1.640e-01, 1.319e-02, -6.323e-02) * s0_1_1;
	r3 += V4(4.971e-01, -4.022e-01, 7.794e-02, 4.318e-01) * s0_1_1;
	r0 += V4(-2.769e-01, -2.753e-02, -5.606e-02, 5.000e-03) * s0_1_2;
	r1 += V4(1.659e-03, 2.083e-03, 2.280e-01, -3.760e-01) * s0_1_2;
	r2 += V4(-8.957e-02, -1.988e-01, 1.971e-02, -6.488e-02) * s0_1_2;
	r3 += V4(1.115e-02, 2.279e-02, 1.929e-01, -1.733e-01) * s0_1_2;
	r0 += V4(1.145e-02, 2.557e-01, -2.386e-01, -4.223e-02) * s0_2_0;
	r1 += V4(6.952e-03, 4.429e-01, -8.143e-02, -4.053e-02) * s0_2_0;
	r2 += V4(-1.770e-02, 2.293e-01, -3.468e-01, -6.811e-02) * s0_2_0;
	r3 += V4(-4.171e-03, 5.598e-02, 1.124e-01, -2.691e-02) * s0_2_0;
	r0 += V4(-2.314e-02, 3.864e-02, -2.115e-01, 5.896e-02) * s0_2_1;
	r1 += V4(1.558e-02, 7.254e-02, -2.070e-01, 1.644e-01) * s0_2_1;
	r2 += V4(-4.587e-02, -1.928e-01, 4.482e-01, 2.441e-01) * s0_2_1;
	r3 += V4(-7.551e-03, -3.017e-02, -1.919e-01, 5.918e-02) * s0_2_1;
	r0 += V4(-6.682e-03, 2.456e-02, 3.507e-02, -2.094e-02) * s0_2_2;
	r1 += V4(-2.388e-02, -2.317e-03, 3.143e-01, -7.193e-02) * s0_2_2;
	r2 += V4(6.590e-02, -3.461e-02, -2.950e-03, -4.834e+00) * s0_2_2;
	r3 += V4(1.942e-03, -1.046e-02, -1.235e+00, -1.038e-01) * s0_2_2;
	r0 += V4(3.867e-03, -1.148e-02, 1.123e-02, -4.502e-01);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(1.726e-02, 8.212e-03, 1.358e-02, -2.052e-02);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
	r2 += V4(-2.032e-03, 2.928e-02, -5.772e-03, 5.972e-02);
	r2 = max(r2, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r2));
	r3 += V4(-7.276e-03, -4.666e-04, 1.798e-02, 1.703e-02);
	r3 = max(r3, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r3));
}

//!DESC CuNNy-4x16-BILINEAR-MPV-NVL-conv1
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
	r0 = D(r0, s0_0_0, 0xBBF1E3DB, 0x250202FE, 0x3B0A230F, 0xFA031F0C);
	r1 = D(r1, s0_0_0, 0xFF030710, 0x02F421E8, 0x4CE6F918, 0x7F080B12);
	r2 = D(r2, s0_0_0, 0xC00AF6E8, 0x7F0612FF, 0xEDFBF0F2, 0xE1030D04);
	r3 = D(r3, s0_0_0, 0xC9050FE9, 0xE40FE5EE, 0x0907F813, 0xFBD7F829);
	r0 = D(r0, s0_0_1, 0x8109F8DC, 0xAA01FCFE, 0x79FF1B09, 0x43F7FCFE);
	r1 = D(r1, s0_0_1, 0x4401F60D, 0x2DF914F4, 0x142BD602, 0x8123F80C);
	r2 = D(r2, s0_0_1, 0x7F03FF07, 0xFC13270A, 0x49031FF8, 0x110BF908);
	r3 = D(r3, s0_0_1, 0x6A1E01F3, 0x0FD1EEFD, 0x51010411, 0x97F2F307);
	r0 = D(r0, s0_0_2, 0x2300EBF7, 0x1203CCFC, 0x531107F3, 0x3201EDEE);
	r1 = D(r1, s0_0_2, 0x94000D0B, 0x3E031609, 0x3C100B0C, 0x8107EE00);
	r2 = D(r2, s0_0_2, 0x510C1911, 0x4202D901, 0x331411F4, 0x0203CEF7);
	r3 = D(r3, s0_0_2, 0x1319FC08, 0x0AF2FC01, 0xD5E122E8, 0x8FEBFF00);
	r0 = D(r0, s0_1_0, 0x81EA1CF7, 0x0EF40714, 0x68F70AFF, 0xEBF4EEE9);
	r1 = D(r1, s0_1_0, 0x81F0FA1C, 0x42ECF6CA, 0x2FE20A2D, 0x4EFD1313);
	r2 = D(r2, s0_1_0, 0x810BFD95, 0x1A090828, 0xA9F1FA13, 0x210A3F1F);
	r3 = D(r3, s0_1_0, 0x130606E9, 0x96F7EDD3, 0x3319FD48, 0xD520EF1A);
	r0 = D(r0, s0_1_1, 0x7FF4E401, 0xD3E304FF, 0x7F0F0F26, 0x3CFDCAE6);
	r1 = D(r1, s0_1_1, 0xE3010CED, 0x7FF8FC16, 0x7F20E208, 0x81F6D615);
	r2 = D(r2, s0_1_1, 0xD3E90CE7, 0x811022FD, 0xF505F81E, 0x7816D811);
	r3 = D(r3, s0_1_1, 0x210B01F6, 0x35FAF303, 0x7FF31B36, 0x4EB6FFF0);
	r0 = D(r0, s0_1_2, 0x192FA813, 0xDB2A17F5, 0x7F04FEF9, 0xD22EE3E3);
	r1 = D(r1, s0_1_2, 0x7FFDEDFC, 0x5FFAED00, 0xE41A0905, 0xDECCE215);
	r2 = D(r2, s0_1_2, 0x28291304, 0x00E6E4FE, 0xDBF626D8, 0xF306D6F5);
	r3 = D(r3, s0_1_2, 0x6BF1EF00, 0x6AED07FD, 0x92DCF501, 0xECFF110B);
	r0 = D(r0, s0_2_0, 0xB50F12C6, 0xF71D1030, 0x35FCFE17, 0xD31324ED);
	r1 = D(r1, s0_2_0, 0x28FF1636, 0x190101F1, 0xCC091DBC, 0x96F1FC44);
	r2 = D(r2, s0_2_0, 0x7FFCD8C7, 0x34FCF832, 0x01F3FFF5, 0xA7122CEC);
	r3 = D(r3, s0_2_0, 0x46FE0204, 0x1E0A10EB, 0xF20406B9, 0xC118F581);
	r0 = D(r0, s0_2_1, 0x81DB3723, 0x5BE6150D, 0x3E081013, 0x81DF0C1E);
	r1 = D(r1, s0_2_1, 0xC10701F5, 0x28FAFAF4, 0x81100E32, 0x24FEEEE4);
	r2 = D(r2, s0_2_1, 0x81EBFCE3, 0x63F5FAF2, 0x66FDEF31, 0xA90F1900);
	r3 = D(r3, s0_2_1, 0x070412F5, 0x19171B25, 0xF4E4E204, 0x09F40D27);
	r0 = D(r0, s0_2_2, 0x810A360B, 0x650FF4F7, 0x6B051900, 0x81FC22C7);
	r1 = D(r1, s0_2_2, 0x4BF0EEFB, 0x5D0CFA05, 0xABE90819, 0xBD0F0B13);
	r2 = D(r2, s0_2_2, 0x81E202FF, 0x56F5F307, 0x38F7DB00, 0x19F8F8F2);
	r3 = D(r3, s0_2_2, 0xE309E905, 0xCA151FF6, 0x52F4ECEC, 0xBB1B2129);
	r0 = D(r0, s1_0_0, 0x08F6FFF9, 0x08ECFFF6, 0xF10200EF, 0xFB0B02F8);
	r1 = D(r1, s1_0_0, 0xE02BFD01, 0x27120A0A, 0xF41F06EB, 0xFAC2FBD2);
	r2 = D(r2, s1_0_0, 0xDC1CFE13, 0x1AE100EF, 0x0AE101FD, 0x10E600E7);
	r3 = D(r3, s1_0_0, 0x250807FA, 0x281AFE16, 0xF4F4F513, 0x040102FA);
	r0 = D(r0, s1_0_1, 0x0A24FD04, 0xFDFF0611, 0xFBF5F3F7, 0x08150311);
	r1 = D(r1, s1_0_1, 0xE2090AE7, 0x04ED0EFB, 0xE108DFFE, 0xF709F4F3);
	r2 = D(r2, s1_0_1, 0x1C2AFBEA, 0x0210FDFF, 0x0305FF0F, 0xFDDCE2E3);
	r3 = D(r3, s1_0_1, 0x243A0316, 0x0D3213EC, 0xF8CEFA02, 0xF51521F6);
	r0 = D(r0, s1_0_2, 0xF500EFE9, 0x12170107, 0x0E01FB07, 0x2BE603F9);
	r1 = D(r1, s1_0_2, 0xEDFEFF09, 0xF60202FE, 0xFB00DCF0, 0xFF02EDFE);
	r2 = D(r2, s1_0_2, 0xD807DDED, 0x0BED0702, 0x270AF5F3, 0x15FD0706);
	r3 = D(r3, s1_0_2, 0xF014E2F4, 0x09FF1B0D, 0x24030E1B, 0x13E3F904);
	r0 = D(r0, s1_1_0, 0xE10D0AF8, 0x170301F6, 0xFF2404F5, 0x06000E13);
	r1 = D(r1, s1_1_0, 0x58510537, 0xECE60F12, 0xDDBE12E1, 0x2ECE02ED);
	r2 = D(r2, s1_1_0, 0x5D020D35, 0x0CF302E9, 0x001904D9, 0xE92504DD);
	r3 = D(r3, s1_1_0, 0x1F25EF06, 0x410014EA, 0xD6EBED21, 0x10DA08CF);
	r0 = D(r0, s1_1_1, 0xDF00FE15, 0xF3E230F9, 0xF603F600, 0xE5D1F3FC);
	r1 = D(r1, s1_1_1, 0x1AF2FDF1, 0xF704FED6, 0x203DFA2B, 0x0A1C0D15);
	r2 = D(r2, s1_1_1, 0x14DEFC1E, 0xFB19E53C, 0xFECF2A45, 0xCBF0E0ED);
	r3 = D(r3, s1_1_1, 0x191806E1, 0x09151181, 0xA5B3FBE6, 0x02E6FC12);
	r0 = D(r0, s1_1_2, 0x0021D8CB, 0xF8060E07, 0x12F7F5FB, 0x2301E3F6);
	r1 = D(r1, s1_1_2, 0x17FAFE06, 0x08ED01F5, 0xEFF781F8, 0xCA15171B);
	r2 = D(r2, s1_1_2, 0x15DEB30E, 0x060110FA, 0x12E41A11, 0xF4FDEF05);
	r3 = D(r3, s1_1_2, 0x08F781E6, 0x16FD08E2, 0x03102005, 0xF9FDED23);
	r0 = D(r0, s1_2_0, 0x1CE7E9F6, 0xE712E20F, 0xDF0103F7, 0x20DB0006);
	r1 = D(r1, s1_2_0, 0xE51802EA, 0xEEFF04EA, 0x70170807, 0xF8EE0AE2);
	r2 = D(r2, s1_2_0, 0xD8F9042F, 0xECF805FD, 0x1E2206EF, 0xFE03F315);
	r3 = D(r3, s1_2_0, 0xFDF002EA, 0x030AFD00, 0x3A04FF2A, 0x3FEE05EF);
	r0 = D(r0, s1_2_1, 0xF9012222, 0xEA0514D2, 0xF2F4FD19, 0x08410110);
	r1 = D(r1, s1_2_1, 0xF9F3F610, 0xE6F80430, 0xC732C411, 0xE7F8051F);
	r2 = D(r2, s1_2_1, 0x1CED011D, 0xE61009D8, 0xF9F30D2C, 0x1C09F722);
	r3 = D(r3, s1_2_1, 0x00EB0001, 0x11F8F022, 0xF2E6FEDE, 0xF3FE07C0);
	r0 = D(r0, s1_2_2, 0xE1EA16FF, 0xF3FC10EE, 0xF90A0803, 0x12E5322A);
	r1 = D(r1, s1_2_2, 0x03000101, 0xF10B13F0, 0xF908E200, 0xFFFCFFE0);
	r2 = D(r2, s1_2_2, 0x0904261B, 0xF70B08FC, 0xFE042504, 0x20FEF2E5);
	r3 = D(r3, s1_2_2, 0xF91609FF, 0x0C07EE29, 0x04F71BEA, 0xE117D35C);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x2F010211, 0x22080804, 0xE92300FF, 0xFF08FE07);
	r1 = D(r1, s0_0_0, 0xE50108F9, 0x2509F811, 0x1EE90328, 0x7F2BED02);
	r2 = D(r2, s0_0_0, 0x9BFAEAEA, 0x2714E908, 0xD3F30407, 0x161A06FF);
	r3 = D(r3, s0_0_0, 0x40101203, 0x0FE324E4, 0x81FDF0E6, 0xC7E3DE40);
	r0 = D(r0, s0_0_1, 0x19ED030E, 0xE9DE1BF4, 0xEC26F813, 0xD8FDFD0A);
	r1 = D(r1, s0_0_1, 0x1427DA00, 0x13FA100F, 0x0021F101, 0x49E5F0FB);
	r2 = D(r2, s0_0_1, 0x12F3E105, 0xE90DFEF6, 0xEEE81707, 0xE525141D);
	r3 = D(r3, s0_0_1, 0x0EFBE1DF, 0xF4E8F133, 0xF706D6EA, 0x0BDE01FB);
	r0 = D(r0, s0_0_2, 0x05D20FF4, 0xF7E6F8EE, 0xF8DCF2EB, 0x0005DD03);
	r1 = D(r1, s0_0_2, 0xFCF30C0E, 0xFD0903FD, 0xCFDFFDEF, 0x2DD1F904);
	r2 = D(r2, s0_0_2, 0x0AA80CF3, 0xF436F215, 0xFBEDE5F4, 0xEE27FEFC);
	r3 = D(r3, s0_0_2, 0x10E532C6, 0xFBFF0103, 0x01C70A12, 0xF8CCF90A);
	r0 = D(r0, s0_1_0, 0x5C001612, 0xAB19DDFB, 0x2D03E601, 0x01EB0006);
	r1 = D(r1, s0_1_0, 0x0808F61D, 0x0C09081A, 0xEE2B0B16, 0x2F07FCE4);
	r2 = D(r2, s0_1_0, 0x29E3EC04, 0x020301F1, 0xFC10031B, 0x1F1B06DF);
	r3 = D(r3, s0_1_0, 0x21F8ECD1, 0x070C22F4, 0xDCE90AF4, 0xD62AFBEA);
	r0 = D(r0, s0_1_1, 0xEF881222, 0x0544F329, 0xF11BF622, 0x28F01A02);
	r1 = D(r1, s0_1_1, 0xF1F5BDCF, 0x19FD1A12, 0xDEC9FBDB, 0x2B11F031);
	r2 = D(r2, s0_1_1, 0xFD02D28B, 0x1B161525, 0xF6FAFF00, 0xE215131F);
	r3 = D(r3, s0_1_1, 0xCF09ECDE, 0xF02ED8CB, 0xF4052FEB, 0x0CFD20EB);
	r0 = D(r0, s0_1_2, 0x1834DCE8, 0x16E627DF, 0x021503FB, 0xFAD613E8);
	r1 = D(r1, s0_1_2, 0xF31EE7FA, 0x09FD0B06, 0x13A7FFE9, 0xF70823F8);
	r2 = D(r2, s0_1_2, 0x0041DCF7, 0xF0EE051B, 0xF32E1320, 0x0B1709FD);
	r3 = D(r3, s0_1_2, 0xD3F3019A, 0xF70CE61E, 0x24F02EE9, 0xD11D14D5);
	r0 = D(r0, s0_2_0, 0xD3F5FB0C, 0xF7F9FB03, 0xF2FEF909, 0x002BD700);
	r1 = D(r1, s0_2_0, 0xEC15EDFF, 0x05040A08, 0xD31607B9, 0x0D09FB10);
	r2 = D(r2, s0_2_0, 0x03ED33FF, 0xF7FFF801, 0x1D00F10A, 0x0C0EF8F0);
	r3 = D(r3, s0_2_0, 0x2A07FA09, 0xFA0000EB, 0xEEFCFBFB, 0xFBEF0BAF);
	r0 = D(r0, s0_2_1, 0x041FAF39, 0x05082514, 0x0C0001F3, 0xF50CFD1C);
	r1 = D(r1, s0_2_1, 0x02F30310, 0x010FFD1F, 0xFFF30C84, 0xF90CFBA9);
	r2 = D(r2, s0_2_1, 0x0DE81CEE, 0x0D0B00E9, 0x0301FA33, 0xEC1EEB03);
	r3 = D(r3, s0_2_1, 0xF6290313, 0xFA02E4E1, 0x14F2E923, 0xFE141C81);
	r0 = D(r0, s0_2_2, 0x0E040BD8, 0x05251DD0, 0xFB110D0A, 0x08CFCC9B);
	r1 = D(r1, s0_2_2, 0x040E0501, 0x030C140F, 0x0F0604EA, 0x091AF00B);
	r2 = D(r2, s0_2_2, 0xF616FDEF, 0xFE04FF38, 0x071D121B, 0x03F0EAE5);
	r3 = D(r3, s0_2_2, 0x031C0DFA, 0xFC0A06EE, 0xF0FC0FFE, 0x071C098E);
	r0 = D(r0, s1_0_0, 0x0D26FCF4, 0x060C03F7, 0xF9810A0B, 0xF20511F6);
	r1 = D(r1, s1_0_0, 0xDDD8F602, 0xE310FDFA, 0xF0FB160D, 0xD34E1523);
	r2 = D(r2, s1_0_0, 0xF2EA1E02, 0xED251C07, 0x11E5F8FF, 0xFCE3FE21);
	r3 = D(r3, s1_0_0, 0x0BCBF7FA, 0x0581DDF8, 0x0B811309, 0xFDA54AE4);
	r0 = D(r0, s1_0_1, 0xE6EC260C, 0xF518F305, 0x100D1500, 0x100223F6);
	r1 = D(r1, s1_0_1, 0x180AF101, 0xFDFEFBF2, 0x1832470F, 0xC33E030B);
	r2 = D(r2, s1_0_1, 0x25E03318, 0xFD22FAFE, 0xF2EC0AFE, 0xF12403F7);
	r3 = D(r3, s1_0_1, 0xF1DE0E03, 0xE73CEDF0, 0x2AEEF8F7, 0xE7F02300);
	r0 = D(r0, s1_0_2, 0xF4E2FC15, 0x04E8F8FF, 0x00040004, 0x15080909);
	r1 = D(r1, s1_0_2, 0xFE13F1F8, 0xF518FD0B, 0xE50C2823, 0xE3EB1202);
	r2 = D(r2, s1_0_2, 0xF107F40F, 0x07250CFA, 0x0F0DFC0C, 0x0FF4FBFE);
	r3 = D(r3, s1_0_2, 0x0523F417, 0xED0D08F8, 0xE40207FC, 0xE0361E0B);
	r0 = D(r0, s1_1_0, 0x2215ECE8, 0xF4ED0904, 0x0612090A, 0x0CE8F3FA);
	r1 = D(r1, s1_1_0, 0xC91B0BC4, 0xE910E2D8, 0xF6E4071E, 0xD850FD16);
	r2 = D(r2, s1_1_0, 0xCDED1CEA, 0xFEDAFA1D, 0xFBF7FBEE, 0x2809D465);
	r3 = D(r3, s1_1_0, 0x11D511F5, 0x183FDAD6, 0x0A1A1B05, 0xF7E138E8);
	r0 = D(r0, s1_1_1, 0xE84A1EDE, 0x16071DC8, 0xED1F1924, 0xDCF4F50E);
	r1 = D(r1, s1_1_1, 0x29071A38, 0x4F05EC36, 0x10EBFDA5, 0xEEF745AA);
	r2 = D(r2, s1_1_1, 0xE2F8D451, 0xE91D1EED, 0x01FB06F3, 0xC20DF1C2);
	r3 = D(r3, s1_1_1, 0x0D18F181, 0x182931EA, 0x37DC1F28, 0x285B1CF5);
	r0 = D(r0, s1_1_2, 0xF6FDEE31, 0x04D7C2E4, 0xFE08FD01, 0x0FE31522);
	r1 = D(r1, s1_1_2, 0x0109210A, 0xF4F61916, 0xF0C1F14F, 0x0319DB07);
	r2 = D(r2, s1_1_2, 0x0D081626, 0x0012100D, 0x09FFF1F0, 0x07F4F1F2);
	r3 = D(r3, s1_1_2, 0x01F7F9B1, 0x051412F4, 0xD9FD01CE, 0xFB1E1418);
	r0 = D(r0, s1_2_0, 0x2861D3D6, 0xD1FD302F, 0xF718090E, 0xE1C8211F);
	r1 = D(r1, s1_2_0, 0xF40F1737, 0x04F7E7FC, 0xEE15C693, 0x05E9E9F8);
	r2 = D(r2, s1_2_0, 0x4917E9D5, 0x0A071AFB, 0xEB0720E4, 0x0EFBFB0D);
	r3 = D(r3, s1_2_0, 0x03EA0925, 0xFCFBF81D, 0x061C1015, 0x130BFC83);
	r0 = D(r0, s1_2_1, 0x4700EC96, 0x05171334, 0xFDF31712, 0x08B70EE6);
	r1 = D(r1, s1_2_1, 0x17FC0DB4, 0xDEFF11E6, 0x071DD981, 0x2202D224);
	r2 = D(r2, s1_2_1, 0xF8EB0C15, 0x16F80558, 0x0B0638C1, 0x12213400);
	r3 = D(r3, s1_2_1, 0xED0540C1, 0xF2081CC0, 0xDDF203C8, 0xF6E5FDB3);
	r0 = D(r0, s1_2_2, 0x021CC90A, 0x02F9F5F4, 0x0911FAF6, 0x3015FA11);
	r1 = D(r1, s1_2_2, 0xF80802F8, 0xF508F413, 0x170F02F8, 0x000D22F9);
	r2 = D(r2, s1_2_2, 0xFD1B1CFD, 0xF709FFF8, 0xFBFCF7F3, 0xF2FC2811);
	r3 = D(r3, s1_2_2, 0xF1060DEE, 0xF903F9F5, 0x0B061333, 0x05FB09EA);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(4.871e-03, -7.228e-03, -2.007e-01, 2.765e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(7.374e-03, -7.853e-03, 2.087e-02, 1.339e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(8.561e-04, 2.582e-02, -3.495e-03, 2.003e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(3.749e-02, 4.359e-02, -1.972e-02, 2.228e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-BILINEAR-MPV-NVL-conv2
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
	r0 = D(r0, s0_0_0, 0x0AF0FA0C, 0xFD0603F7, 0xF602EFF2, 0x0A0C03FC);
	r1 = D(r1, s0_0_0, 0x0AFBF922, 0xFD01ECF4, 0xEDF20901, 0x0713FFE2);
	r2 = D(r2, s0_0_0, 0xFC0108FF, 0x0D01FCFE, 0xD8F812E9, 0xF905FA10);
	r3 = D(r3, s0_0_0, 0x12FD01EC, 0xF4191FFF, 0x0CEF0307, 0xFFF1EADB);
	r0 = D(r0, s0_0_1, 0x201AECE3, 0xF00AFF02, 0xDAED01E0, 0xFB1D022B);
	r1 = D(r1, s0_0_1, 0x3EF6F8BC, 0xECE4F1B1, 0xF400F5E6, 0x090312EA);
	r2 = D(r2, s0_0_1, 0xDDFA01EE, 0x0FFF05F3, 0xEE061502, 0x0A00D1AD);
	r3 = D(r3, s0_0_1, 0x0AF5F91E, 0xCE0ECFBB, 0x110BFCFE, 0xF500F276);
	r0 = D(r0, s0_0_2, 0xFCF80D08, 0xF1FCF60B, 0xF7FFEED9, 0xF53BEFF6);
	r1 = D(r1, s0_0_2, 0xC808F4A1, 0x0508EBEB, 0xF6060BF5, 0xEFF9E3FE);
	r2 = D(r2, s0_0_2, 0xE9000B02, 0xFC00000D, 0x0B0D0225, 0xFCF72C05);
	r3 = D(r3, s0_0_2, 0x05061126, 0xD03219E2, 0xFA0D0BFE, 0xF301F9F0);
	r0 = D(r0, s0_1_0, 0xF7FAFE10, 0x0BE70AFA, 0x02F7F4E5, 0xFA080324);
	r1 = D(r1, s0_1_0, 0x08ECE833, 0x43F60CE7, 0xDFF9F5F0, 0x110214F0);
	r2 = D(r2, s0_1_0, 0x0111F9EF, 0x0A0D1717, 0xD9F4200E, 0x03060701);
	r3 = D(r3, s0_1_0, 0xEF192514, 0x380CE511, 0x26FC09EC, 0x40EFF803);
	r0 = D(r0, s0_1_1, 0x3BF90700, 0xFB0B1A17, 0xF023ABFF, 0xBB210B17);
	r1 = D(r1, s0_1_1, 0xFEFED7BD, 0x1D21EEC4, 0xD5FF12F5, 0x0DE1F140);
	r2 = D(r2, s0_1_1, 0xE2F1F5EB, 0x17F920FA, 0xEEF11311, 0x2CFB340B);
	r3 = D(r3, s0_1_1, 0xEFF306F7, 0x108FE9DC, 0x150824DE, 0x1E24E92C);
	r0 = D(r0, s0_1_2, 0xF305050F, 0x01FC0001, 0xFBFCE2F4, 0xF716EE16);
	r1 = D(r1, s0_1_2, 0xCEF8FB4C, 0x1903FF03, 0xFB0B0C04, 0x0504EAF6);
	r2 = D(r2, s0_1_2, 0xEA0D1704, 0xF100190D, 0xFFEB0503, 0xF618C629);
	r3 = D(r3, s0_1_2, 0xF4FA0910, 0xFBF417F9, 0xF10B1503, 0xF4FFE9E4);
	r0 = D(r0, s0_2_0, 0xF903FB08, 0x050606F9, 0x03FBFDFA, 0xFC0FFEFF);
	r1 = D(r1, s0_2_0, 0xE91D022D, 0xDE130316, 0xF204FA08, 0x1AF7EBF0);
	r2 = D(r2, s0_2_0, 0x060410F8, 0xFC10FC09, 0xF7140AF3, 0x0504F60A);
	r3 = D(r3, s0_2_0, 0x06F607FC, 0xF716F914, 0xFB02F814, 0xF5E8FD07);
	r0 = D(r0, s0_2_1, 0x05F8FBFD, 0x01F90503, 0xF502F701, 0x1140FCE0);
	r1 = D(r1, s0_2_1, 0xE32AEB02, 0xFCCC14F6, 0xFE0A06F9, 0x0121E50A);
	r2 = D(r2, s0_2_1, 0xF30A10FA, 0x0BF0F7F2, 0x0D0D04F6, 0x010705F6);
	r3 = D(r3, s0_2_1, 0xFCF314FE, 0xFFFEFD15, 0x05E91101, 0xF716CC1A);
	r0 = D(r0, s0_2_2, 0x03FEFAFE, 0xFEFF0105, 0x06FF0207, 0x0F2DEB02);
	r1 = D(r1, s0_2_2, 0xF2FCFE04, 0xEC19F508, 0xFDF302FA, 0xF701FC04);
	r2 = D(r2, s0_2_2, 0xFD010C04, 0x010A02FC, 0x110903FA, 0x0FEB0310);
	r3 = D(r3, s0_2_2, 0x090A06F7, 0x0312F0FF, 0x03FBFB02, 0x03F7FFFA);
	r0 = D(r0, s1_0_0, 0xFD0D1209, 0x12F9FBFC, 0x26E9F103, 0x0802F702);
	r1 = D(r1, s1_0_0, 0xECEC080B, 0x04FAFEF5, 0x0BFBF801, 0x01F2F7FD);
	r2 = D(r2, s1_0_0, 0xFCF1FAFD, 0x03030401, 0xFAE8EDEA, 0x0E03F9F5);
	r3 = D(r3, s1_0_0, 0xFA00EEF8, 0x010204F7, 0xFBFC0701, 0x07E40708);
	r0 = D(r0, s1_0_1, 0x19EDE604, 0x12080107, 0x01210501, 0x0DF1FA04);
	r1 = D(r1, s1_0_1, 0x20FAE5E7, 0x080D00ED, 0x0CF90301, 0x10090306);
	r2 = D(r2, s1_0_1, 0xFC17F109, 0x00EC04F3, 0x06F709F0, 0x202219F4);
	r3 = D(r3, s1_0_1, 0xEDF406FD, 0x16FAF3FA, 0x0B010BFA, 0xEEF5DF24);
	r0 = D(r0, s1_0_2, 0xF2160B38, 0xFF0C0903, 0x0CEFF90D, 0x0CFDF7FC);
	r1 = D(r1, s1_0_2, 0x09E506F8, 0x18E81BDE, 0x05F8F8FD, 0x041905FA);
	r2 = D(r2, s1_0_2, 0xFBFAFC03, 0x02FF06F6, 0x01F90EED, 0xD2E8E63B);
	r3 = D(r3, s1_0_2, 0xEE0205F8, 0x02F203EB, 0xFCFC02F0, 0x0A06FCEC);
	r0 = D(r0, s1_1_0, 0xF9FC080A, 0x17051202, 0xE6FF0FFE, 0xF00802FF);
	r1 = D(r1, s1_1_0, 0x01D0F913, 0x27FF09FC, 0x09FCFAFD, 0xFB1117FF);
	r2 = D(r2, s1_1_0, 0x0301FFF3, 0xFEFDF5FF, 0x0B0911F3, 0xEE170E21);
	r3 = D(r3, s1_1_0, 0xF90F04FD, 0x0A1A0108, 0x14F4EE00, 0x10102305);
	r0 = D(r0, s1_1_1, 0x280AC2E4, 0x2B13DDF9, 0xD8201F10, 0xB5122C08);
	r1 = D(r1, s1_1_1, 0x812901D5, 0xE313E718, 0xF6F1112E, 0xE308FDFB);
	r2 = D(r2, s1_1_1, 0xDB0D101B, 0xF3E7D4EB, 0xFF08D9FB, 0xAE040A43);
	r3 = D(r3, s1_1_1, 0xE8E1F110, 0xC5FF0F4E, 0x34DEF8F3, 0xBF173DC8);
	r0 = D(r0, s1_1_2, 0xEE173C0A, 0x09020415, 0x0AF408EC, 0xEFF81AE8);
	r1 = D(r1, s1_1_2, 0x010A1ED0, 0x27CE0437, 0x0CFDF2F3, 0xFB070411);
	r2 = D(r2, s1_1_2, 0x0BF5F11B, 0xF7E7002A, 0x0200E706, 0xDED7FAF7);
	r3 = D(r3, s1_1_2, 0x0C05F20B, 0xFAF60917, 0xF30A0804, 0x01F800AE);
	r0 = D(r0, s1_2_0, 0xFFF80402, 0x16FE0BFE, 0xFEEF20FF, 0xFCF1EDFD);
	r1 = D(r1, s1_2_0, 0x0DCCD409, 0xF4E0391A, 0xEE0CECF5, 0xE0DEDFF6);
	r2 = D(r2, s1_2_0, 0x170D1308, 0x0DF8EB04, 0x11F10DF4, 0x120A0B09);
	r3 = D(r3, s1_2_0, 0xF80413FB, 0x0D07EADB, 0x05010402, 0x1F03E50D);
	r0 = D(r0, s1_2_1, 0x0107F704, 0x170CFAEF, 0x0D0EB904, 0xFFF428F8);
	r1 = D(r1, s1_2_1, 0xE41FA907, 0xB9B4142B, 0xFDF0F91C, 0xE7F410ED);
	r2 = D(r2, s1_2_1, 0x0EEBF2FE, 0x17E92227, 0x0F07F8FC, 0xECBF05E7);
	r3 = D(r3, s1_2_1, 0xEFE10C09, 0x1A2EDAC3, 0x0C0706F1, 0xFB07D70E);
	r0 = D(r0, s1_2_2, 0xFAE303F3, 0x00F70104, 0x0A00EA2E, 0xFFEC0307);
	r1 = D(r1, s1_2_2, 0xDEAD0136, 0xF2C0FBEE, 0x0EF3EC0E, 0x0CFB0AEF);
	r2 = D(r2, s1_2_2, 0x020BF720, 0xF6C015EA, 0xFCE8DFED, 0xC92DF1D3);
	r3 = D(r3, s1_2_2, 0xFC06F9ED, 0x131C0C09, 0xF2000CE3, 0x0DD5EF0F);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x0BEF04ED, 0x060E000D, 0x0719F4FB, 0x02F1FAFC);
	r1 = D(r1, s0_0_0, 0xEFCD1C0A, 0xFA1315E6, 0x02FBFF06, 0xFCFB0200);
	r2 = D(r2, s0_0_0, 0x0015F9F9, 0xFFEF06FC, 0xFA030320, 0xECF00FFE);
	r3 = D(r3, s0_0_0, 0x05040009, 0xF1E006F5, 0xFEF406FC, 0x2A09E60A);
	r0 = D(r0, s0_0_1, 0x0BFFF706, 0x02EE0EFF, 0xF9FF00F6, 0x071AF710);
	r1 = D(r1, s0_0_1, 0x0C060317, 0x0A22F1B6, 0x0DFF0E11, 0x0BF5FEF8);
	r2 = D(r2, s0_0_1, 0x0AEB09F3, 0x10FD0C12, 0xDCF61635, 0x05B10F0E);
	r3 = D(r3, s0_0_1, 0x0FF70D11, 0x19F90E05, 0xFB040205, 0xDF0A1BD2);
	r0 = D(r0, s0_0_2, 0xF209F7FA, 0xFBF60107, 0x01FF08FB, 0xE6E90C11);
	r1 = D(r1, s0_0_2, 0xFF16F61A, 0xFEDE0506, 0xFA03FE07, 0x09F70C08);
	r2 = D(r2, s0_0_2, 0xF7F205F2, 0xFF0001F7, 0xF20FFB1E, 0x330F1ED8);
	r3 = D(r3, s0_0_2, 0xE7F30205, 0xF1060018, 0xF5010911, 0xF2EB1012);
	r0 = D(r0, s0_1_0, 0xFAEA12F7, 0x0807F706, 0x081BF500, 0x0FF6010F);
	r1 = D(r1, s0_1_0, 0xF0D041FD, 0x2ED4ACEC, 0xF6FDFE12, 0xFA13FFD9);
	r2 = D(r2, s0_1_0, 0x0A15F703, 0xE4E615F9, 0xDE06FE27, 0x13E719FE);
	r3 = D(r3, s0_1_0, 0xEEF40114, 0x0D1D04F5, 0x01FC090F, 0xF201EAF6);
	r0 = D(r0, s0_1_1, 0xDF1A1817, 0x23102F00, 0x1424C8BE, 0x0402E611);
	r1 = D(r1, s0_1_1, 0xE2F6F828, 0x29D3FD3F, 0xF2F70F0D, 0xD4E71BCA);
	r2 = D(r2, s0_1_1, 0xE9020008, 0xEDDE2828, 0xD4172855, 0xF1353C0C);
	r3 = D(r3, s0_1_1, 0xFDFB3623, 0x0B2CC02B, 0x110F112F, 0xC9EBD6AC);
	r0 = D(r0, s0_1_2, 0xCAF8C902, 0xFA080207, 0x12FD0203, 0x17DE05FA);
	r1 = D(r1, s0_1_2, 0xE8FAE7D4, 0xF42D3B0C, 0x0C0FFE18, 0x16F9FF02);
	r2 = D(r2, s0_1_2, 0x220C2401, 0x0C0B0305, 0xDF0CED41, 0xD71FABBB);
	r3 = D(r3, s0_1_2, 0x04061F25, 0x14F7F91B, 0xFA08FE14, 0x121600CD);
	r0 = D(r0, s0_2_0, 0xFEFD09FE, 0xFA0CF60B, 0x090F060C, 0x110EF301);
	r1 = D(r1, s0_2_0, 0xF4142B15, 0x2DE8EFE8, 0xE8FE2A1B, 0x0521F7ED);
	r2 = D(r2, s0_2_0, 0x0708DAF4, 0x0CF5EDF5, 0x0216E616, 0xF2010EF5);
	r3 = D(r3, s0_2_0, 0x1BFBE1F6, 0xF1100A1A, 0xDF001204, 0xF4380D04);
	r0 = D(r0, s0_2_1, 0xE9110B04, 0xFCFBF10B, 0x050724FE, 0x0FF9E611);
	r1 = D(r1, s0_2_1, 0x182FFF08, 0xAE2306F9, 0xF008EA2B, 0xF9FA1ABA);
	r2 = D(r2, s0_2_1, 0x010EE410, 0x0519F1FF, 0xF5F2E320, 0x04F4DA04);
	r3 = D(r3, s0_2_1, 0x0AED0117, 0xB30A08F2, 0xD0FADE10, 0xE7FA2413);
	r0 = D(r0, s0_2_2, 0xECF0E410, 0xFBFD06FB, 0xFB0C17D9, 0xF4010C17);
	r1 = D(r1, s0_2_2, 0x2AF2DA46, 0xE5EB00F4, 0x0100F831, 0x09061301);
	r2 = D(r2, s0_2_2, 0x000104FF, 0x00ECED1C, 0xEC08F12F, 0xF0FDC5EC);
	r3 = D(r3, s0_2_2, 0x0D0BFA33, 0xF4F507D4, 0xE9F2E62D, 0xEF02101D);
	r0 = D(r0, s1_0_0, 0xF30CF602, 0x0F0A05F9, 0x16F60EFE, 0xF80BF2E7);
	r1 = D(r1, s1_0_0, 0x0900EDEE, 0x101E1D38, 0x030D0604, 0x140302FC);
	r2 = D(r2, s1_0_0, 0x14FC0CFA, 0xCEEBF90A, 0x06151206, 0x101E09E7);
	r3 = D(r3, s1_0_0, 0x00F80606, 0xF11706E1, 0xFA17F507, 0x121006E8);
	r0 = D(r0, s1_0_1, 0x0FDAFAD3, 0x00080A04, 0xFCFC1614, 0x090FF8F6);
	r1 = D(r1, s1_0_1, 0x2B0F1013, 0xB6190008, 0x0407F5F7, 0xF31D1103);
	r2 = D(r2, s1_0_1, 0x0F07030C, 0xF6FAFCF6, 0xED28F304, 0xDED2F318);
	r3 = D(r3, s1_0_1, 0x020DF801, 0xF71FF2F8, 0xFE0A080F, 0x03FE0102);
	r0 = D(r0, s1_0_2, 0xF40DFC19, 0xF800000A, 0x1003FCF3, 0x00FF04F7);
	r1 = D(r1, s1_0_2, 0xF401F107, 0xF60BE405, 0x040200F8, 0xF508F805);
	r2 = D(r2, s1_0_2, 0x0503F7F7, 0xE902050A, 0xFD0DFC1B, 0x2600E6EF);
	r3 = D(r3, s1_0_2, 0x0C03FF13, 0xF2F20404, 0xF9070204, 0x0513F000);
	r0 = D(r0, s1_1_0, 0x073FFC04, 0xFF12FD06, 0x060EF902, 0x031EF2F7);
	r1 = D(r1, s1_1_0, 0x1C0EF7EF, 0xF701F8EA, 0x05170606, 0xFBF5F1F7);
	r2 = D(r2, s1_1_0, 0xFC121418, 0xF901FFFA, 0x0531FE03, 0xF403FDEF);
	r3 = D(r3, s1_1_0, 0x020CF8E3, 0xF2382D08, 0xFF1D0C04, 0xF803F71B);
	r0 = D(r0, s1_1_1, 0xF2E63203, 0xFE140407, 0x06F6CF05, 0x01171309);
	r1 = D(r1, s1_1_1, 0xF334E815, 0x8403D011, 0xF823F10F, 0x15F1F71C);
	r2 = D(r2, s1_1_1, 0xE62EF714, 0x07EE23EF, 0xEF32FDEB, 0xFBE4CFF4);
	r3 = D(r3, s1_1_1, 0x093BF4DB, 0xD1350A02, 0xFCFA04F7, 0xF1004028);
	r0 = D(r0, s1_1_2, 0x22F5FC10, 0x0E07F8F2, 0x03060C07, 0xF4FFF7FB);
	r1 = D(r1, s1_1_2, 0xD6FA2122, 0xBC0DFFF3, 0x030AF80E, 0xFD0CF5FB);
	r2 = D(r2, s1_1_2, 0xEF13FAF6, 0xFEFFF8F8, 0xE719F01E, 0x08B91022);
	r3 = D(r3, s1_1_2, 0xEB14F50A, 0xE5FC17F6, 0xF5F5F218, 0x1B05EBFD);
	r0 = D(r0, s1_2_0, 0x02EEF407, 0xFDFF06F6, 0x1105FBE8, 0x050200FE);
	r1 = D(r1, s1_2_0, 0x2D4202E6, 0x1C19DBF5, 0xFB02FD11, 0x02B625C7);
	r2 = D(r2, s1_2_0, 0x0125F101, 0xFCD00DFF, 0x06F606F1, 0x14EAE42D);
	r3 = D(r3, s1_2_0, 0x07080F03, 0xE721EC11, 0x0925161E, 0x0115D618);
	r0 = D(r0, s1_2_1, 0xFE0D31F2, 0xFD000110, 0xDEECBF2E, 0x05F402F1);
	r1 = D(r1, s1_2_1, 0xDD5ED416, 0xCEDD10E6, 0xFF250C05, 0x28EF1EF1);
	r2 = D(r2, s1_2_1, 0x06240E01, 0x07F017E4, 0x1D200EF5, 0x11B743EA);
	r3 = D(r3, s1_2_1, 0x28183BFC, 0xB6D8D3FD, 0x01113C0F, 0x0806FC18);
	r0 = D(r0, s1_2_2, 0x120A20F9, 0x04F90004, 0xD902FEF5, 0xFD0509F9);
	r1 = D(r1, s1_2_2, 0xF42DF22C, 0x21EA06F6, 0xFA150805, 0x06F51CEB);
	r2 = D(r2, s1_2_2, 0xFB09ED03, 0x1CF414F8, 0xFB19F704, 0x08DFFF18);
	r3 = D(r3, s1_2_2, 0x0116E012, 0x9AF704EF, 0x1B0708F8, 0x1407FAFF);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(1.715e-02, -1.605e-03, 6.820e-04, -2.314e-01);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-2.513e-02, -4.748e-03, -2.500e-03, 2.266e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(6.389e-03, -1.715e-02, -1.995e-02, -7.825e-03);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(4.818e-03, 6.457e-03, -6.906e-03, 6.588e-03);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-BILINEAR-MPV-NVL-conv3
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
	r0 = D(r0, s0_0_0, 0x7FE2F7DC, 0x40E1FC02, 0xF0FFF6FA, 0xFE05FE05);
	r1 = D(r1, s0_0_0, 0x05F0FE02, 0x05E407F7, 0xFEEFFDF8, 0x08110500);
	r2 = D(r2, s0_0_0, 0xF1EA01FC, 0xE5F8F80B, 0xF8FF03FA, 0x0504FB01);
	r3 = D(r3, s0_0_0, 0xE70FF304, 0x819DA8AB, 0xFA02060A, 0x33ECF206);
	r0 = D(r0, s0_0_1, 0xED251A06, 0x10F413F9, 0x0CEDFAE2, 0xDC1C1205);
	r1 = D(r1, s0_0_1, 0x1F160619, 0xEBF7FFEF, 0xEAE803FB, 0xFE0808F3);
	r2 = D(r2, s0_0_1, 0xF8FF0A02, 0x10FE0BF9, 0xD2EEFAFF, 0xFD0CFD03);
	r3 = D(r3, s0_0_1, 0xFBF2FC01, 0xDE1AC481, 0x12F60507, 0xCD0F0F20);
	r0 = D(r0, s0_0_2, 0x0615FDFD, 0x03EC2DED, 0x01FC1AF4, 0xFA0B03F9);
	r1 = D(r1, s0_0_2, 0x1B05F90F, 0xF6F8EEFC, 0xFEEFFA00, 0x07F7FFFE);
	r2 = D(r2, s0_0_2, 0x10FD0204, 0x0A0E1C00, 0xF716FBFB, 0x010C0600);
	r3 = D(r3, s0_0_2, 0x0303FD03, 0x7F418181, 0x03EAFCFD, 0xB514A481);
	r0 = D(r0, s0_1_0, 0xA581C25D, 0xFB151DFE, 0xCFD73AFD, 0xF70E0B0B);
	r1 = D(r1, s0_1_0, 0x25ED0412, 0xB80201AE, 0xFEDC05EB, 0xEA1AF9F2);
	r2 = D(r2, s0_1_0, 0xF1100006, 0x1C0A2102, 0x1DF90101, 0x0B030003);
	r3 = D(r3, s0_1_0, 0xFAF3FF08, 0xC90258F6, 0xE213F710, 0x3A061909);
	r0 = D(r0, s0_1_1, 0x90B6240A, 0xF91C490E, 0x16DBD9C8, 0xD2063A00);
	r1 = D(r1, s0_1_1, 0xD569D617, 0xDBE535C7, 0xF6BD0CF8, 0xF9290506);
	r2 = D(r2, s0_1_1, 0xEAF70B18, 0xDB1CB718, 0x5BD0D311, 0x2C17110B);
	r3 = D(r3, s0_1_1, 0x66FADE01, 0xF9D79B33, 0x113AF613, 0x9A7FF306);
	r0 = D(r0, s0_1_2, 0x1E1312F2, 0xF110150B, 0x0FF5E10A, 0xEF060CFC);
	r1 = D(r1, s0_1_2, 0xDDE91EF3, 0xEE07F4F3, 0xFBEDE9FF, 0x1C07F5FB);
	r2 = D(r2, s0_1_2, 0x140B0007, 0x1D02AA0C, 0xF7251BFF, 0xFD0AF6FE);
	r3 = D(r3, s0_1_2, 0x0E0905EF, 0x2AFB16F5, 0x010BF3FA, 0xDE9E877F);
	r0 = D(r0, s0_2_0, 0x81AA14F5, 0x35DD04FD, 0xDA0AFEDF, 0xF805FDF8);
	r1 = D(r1, s0_2_0, 0x06FFF407, 0x0206F9D6, 0xE60005ED, 0x0E06FDF9);
	r2 = D(r2, s0_2_0, 0x071A0C04, 0x141FD8E0, 0x08E5E2F9, 0xF607FEFB);
	r3 = D(r3, s0_2_0, 0xE1FE01EC, 0x210AE501, 0x0A010403, 0x36FE13FF);
	r0 = D(r0, s0_2_1, 0xECE41DF8, 0x21F317FB, 0x1006E4DD, 0xFC060C02);
	r1 = D(r1, s0_2_1, 0x0F1901FA, 0xDFF90ED4, 0x290AE7E6, 0x09F5F0E5);
	r2 = D(r2, s0_2_1, 0x1C15CD07, 0xFD210AF6, 0x3E10D7BF, 0x140EEC09);
	r3 = D(r3, s0_2_1, 0xF6F90FFA, 0xFB0700EC, 0xF0F9F302, 0x5417E40C);
	r0 = D(r0, s0_2_2, 0x1EF5FEFE, 0x241319F3, 0xF70729F6, 0xF503FEFF);
	r1 = D(r1, s0_2_2, 0x10EEFC02, 0xFA01F8F9, 0x0E071CF9, 0x02F403F9);
	r2 = D(r2, s0_2_2, 0x050511FC, 0xD6EC40E8, 0xE90815FF, 0xFC05FCFF);
	r3 = D(r3, s0_2_2, 0xE80110FE, 0xE8041FF9, 0xF6FF03FA, 0x7F81810B);
	r0 = D(r0, s1_0_0, 0xFBB68189, 0xF2E331FA, 0x03EAF7ED, 0x0407FF05);
	r1 = D(r1, s1_0_0, 0x04F60908, 0x080E02F4, 0x00F4E318, 0xFE0711F9);
	r2 = D(r2, s1_0_0, 0x1105E8EC, 0x0C0100DC, 0xF6FB03FC, 0xFFFF1210);
	r3 = D(r3, s1_0_0, 0x07F9220B, 0xC4A60130, 0xF9050205, 0x08120DD9);
	r0 = D(r0, s1_0_1, 0x1F4AFF2D, 0xCCF1090D, 0xF2E7B0D1, 0xFA0C0219);
	r1 = D(r1, s1_0_1, 0xDC0515E2, 0x1B1DDBF5, 0x17F6C907, 0x022F1611);
	r2 = D(r2, s1_0_1, 0x0AFEFD14, 0xFADD20D1, 0x02151904, 0xFE001614);
	r3 = D(r3, s1_0_1, 0xF70C2EFC, 0xDD1E1481, 0xFE1705FE, 0xDC0D0A31);
	r0 = D(r0, s1_0_2, 0x00040DF1, 0xDE1B1F03, 0xF907EBF8, 0x001006FD);
	r1 = D(r1, s1_0_2, 0x060D211D, 0x1213EDEC, 0x0A17E6F5, 0xF5DC05F0);
	r2 = D(r2, s1_0_2, 0x01070001, 0xFAF721FB, 0x07E11C07, 0xF0F00C0A);
	r3 = D(r3, s1_0_2, 0xEEEC260D, 0x29490863, 0xF7CDEAF3, 0x1BBE5081);
	r0 = D(r0, s1_1_0, 0xDB816781, 0xF9012B02, 0x0104C438, 0x01021705);
	r1 = D(r1, s1_1_0, 0xF2040213, 0x00F2DC35, 0xFBF8E113, 0x01FD27EE);
	r2 = D(r2, s1_1_0, 0x00F118C5, 0xF50944FF, 0x12032234, 0xF7FA09F5);
	r3 = D(r3, s1_1_0, 0x04F40607, 0x20061DEF, 0xF9FB30DB, 0xF9FE00DC);
	r0 = D(r0, s1_1_1, 0xE0EB0146, 0xE8F600F0, 0x30EBD1EB, 0xEE151008);
	r1 = D(r1, s1_1_1, 0xF80D3CDA, 0x17C0F001, 0x1205E817, 0xF2F0160C);
	r2 = D(r2, s1_1_1, 0xEDED1D26, 0xFE58292B, 0x0E0CF102, 0x0D430620);
	r3 = D(r3, s1_1_1, 0x1131D221, 0x04E6030E, 0xF12A151E, 0xC5EB35DA);
	r0 = D(r0, s1_1_2, 0xF9170FEF, 0x0422200A, 0x0309B403, 0xFE0208F8);
	r1 = D(r1, s1_1_2, 0x07E0022F, 0x2314F4E9, 0x100FF90C, 0x040F1D04);
	r2 = D(r2, s1_1_2, 0xF4EC0FEB, 0x19E72103, 0xFFF30D2B, 0xFFE81A09);
	r3 = D(r3, s1_1_2, 0x04E70CE0, 0x07E7EB05, 0x14F912FE, 0xF681E781);
	r0 = D(r0, s1_2_0, 0xBF813981, 0xE401E413, 0xED021E14, 0x00FE00FF);
	r1 = D(r1, s1_2_0, 0xFAFE16FB, 0xFD07F408, 0xFD0A08FB, 0x00FD08FD);
	r2 = D(r2, s1_2_0, 0x10002EF0, 0xFAE637F9, 0x06F20FED, 0xFFFB0EFC);
	r3 = D(r3, s1_2_0, 0x07FE0DFD, 0x10FC01F0, 0x01F90204, 0xFB0909EC);
	r0 = D(r0, s1_2_1, 0x0DDFE830, 0xE8051C23, 0xFFEF1ADC, 0x0800FB05);
	r1 = D(r1, s1_2_1, 0xF9080706, 0x06F2EEF8, 0x01181B25, 0x1200EEFC);
	r2 = D(r2, s1_2_1, 0xE61113FD, 0xE6D93BEB, 0xFD05190C, 0xF6F80A03);
	r3 = D(r3, s1_2_1, 0xFB040904, 0xFB13110A, 0x03FFFBFF, 0x160BD51F);
	r0 = D(r0, s1_2_2, 0x07F21BF4, 0xF41B0CF3, 0x040315FF, 0x03FA0E02);
	r1 = D(r1, s1_2_2, 0x05F2E324, 0x0306F3FA, 0xF8040B15, 0x06FFFE0A);
	r2 = D(r2, s1_2_2, 0xFE0118F4, 0x1415EC10, 0xEEEE3021, 0xFFFC0F00);
	r3 = D(r3, s1_2_2, 0xFEF2FE09, 0xF9081A0F, 0xFFF8FE03, 0x8C81FDD1);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x81FD8183, 0xDAFD5A0B, 0x1BF1FB00, 0x080301FA);
	r1 = D(r1, s0_0_0, 0xFDFD0AFC, 0x0FF11BFE, 0x0A01FA0A, 0x07FF05FE);
	r2 = D(r2, s0_0_0, 0x000D1603, 0x0808ED0C, 0x0B0001F5, 0x020AFDFF);
	r3 = D(r3, s0_0_0, 0x0E0E0602, 0x1B813881, 0xF709040A, 0x01F50FEB);
	r0 = D(r0, s0_0_1, 0xFF01FBEE, 0xDB2A22D6, 0x1C1FE0F6, 0x06F1ECFA);
	r1 = D(r1, s0_0_1, 0xFC13E6FA, 0x0804E7EF, 0x0907DFFB, 0x0D0043E7);
	r2 = D(r2, s0_0_1, 0x04F7F104, 0x0CFDE7D2, 0x0CFB000C, 0x0BFB1DFE);
	r3 = D(r3, s0_0_1, 0x15022BE5, 0xA88E8581, 0x0CF816FA, 0xFE2905F7);
	r0 = D(r0, s0_0_2, 0x0215F9FD, 0xDC041119, 0x09EBE302, 0x05F804F1);
	r1 = D(r1, s0_0_2, 0x0CE202EF, 0x0302FAE7, 0x00FCF9E7, 0xFA14050C);
	r2 = D(r2, s0_0_2, 0x040A0A0E, 0x09E40B15, 0x0AEFFEFC, 0x04FC0309);
	r3 = D(r3, s0_0_2, 0x01051104, 0x237FCC81, 0xFE1D0B26, 0x81AEE097);
	r0 = D(r0, s0_1_0, 0x3E7481F1, 0x81F7EFF3, 0x2CCDF3F4, 0x09F60C07);
	r1 = D(r1, s0_1_0, 0xEAF1FE0A, 0x1D03DEE5, 0x170FDBEF, 0xE90A09FB);
	r2 = D(r2, s0_1_0, 0xF92DFB06, 0xE7F128EB, 0xF8E1FCFA, 0x09FB0EFE);
	r3 = D(r3, s0_1_0, 0x18E709F8, 0x10022F17, 0x03141E08, 0xF70A0000);
	r0 = D(r0, s0_1_1, 0x32DF42D3, 0xE50612B2, 0x3CF1B8ED, 0x0C0529DE);
	r1 = D(r1, s0_1_1, 0xF2F3CF29, 0x0909EEE1, 0x0C0FB2EC, 0x1AED0DDB);
	r2 = D(r2, s0_1_1, 0x04D905E4, 0x1E0E1319, 0x2D29FB19, 0x1CED0117);
	r3 = D(r3, s0_1_1, 0x2707E020, 0x0C50EA14, 0x1BF4DEEB, 0xF77C1DF8);
	r0 = D(r0, s0_1_2, 0x0AEA05F0, 0xE3EE00F7, 0x052EF522, 0x0AF503FA);
	r1 = D(r1, s0_1_2, 0x14D112DA, 0x03FD0B0A, 0x09060A13, 0x01110700);
	r2 = D(r2, s0_1_2, 0x05FF0601, 0x1A1CEDEE, 0x1804FB05, 0x090004FD);
	r3 = D(r3, s0_1_2, 0x06140A16, 0x04020A03, 0xFB0802F7, 0xDEA51F7F);
	r0 = D(r0, s0_2_0, 0x81F181B8, 0xCDE41F1B, 0x2419050A, 0x0AFBF5FB);
	r1 = D(r1, s0_2_0, 0xF60CF9F7, 0x0904ECF9, 0x0FF8080C, 0x04ECF3F3);
	r2 = D(r2, s0_2_0, 0x00ED17FC, 0x07F010FB, 0x2129E6F4, 0x0B010502);
	r3 = D(r3, s0_2_0, 0x181004EC, 0x07EAFCFE, 0x0EF70609, 0xF2EC040D);
	r0 = D(r0, s0_2_1, 0x06060338, 0x09FB2E15, 0x3CFEF202, 0x05F7EF09);
	r1 = D(r1, s0_2_1, 0x14D5FD0E, 0x111F16E4, 0x21DEF1FC, 0x1811FBFF);
	r2 = D(r2, s0_2_1, 0x1FFF0511, 0xE6AF00DD, 0xFAE481F7, 0xFFFFEB08);
	r3 = D(r3, s0_2_1, 0xFB0F07E8, 0x19E2E9EE, 0x061701FD, 0x0EEB1212);
	r0 = D(r0, s0_2_2, 0x08190311, 0xE8EFF5F7, 0x23E01EEF, 0x0601FE02);
	r1 = D(r1, s0_2_2, 0x0112FB13, 0x05130207, 0x0CF315F1, 0x030F0EFD);
	r2 = D(r2, s0_2_2, 0x06ED17FC, 0x13DA1D22, 0x26FBFAF2, 0x06F90204);
	r3 = D(r3, s0_2_2, 0x08F21301, 0x19F91007, 0x050E0E03, 0x9D130FEA);
	r0 = D(r0, s1_0_0, 0xF6C6E281, 0x0D1904CD, 0xEFFF0BFB, 0x01FCFCFC);
	r1 = D(r1, s1_0_0, 0xFC03FDF1, 0x0308FBF6, 0xFDFFF7F0, 0x0307010D);
	r2 = D(r2, s1_0_0, 0x06E4F6DC, 0x0511FBE6, 0x05F4F104, 0x0208FA0E);
	r3 = D(r3, s1_0_0, 0x070FF706, 0x074F9FF5, 0xFBF8FD01, 0x05E4F3F2);
	r0 = D(r0, s1_0_1, 0x02BBFE19, 0x04F819BF, 0x0E11FDE5, 0x00F7031C);
	r1 = D(r1, s1_0_1, 0xF5F9F60D, 0x08010500, 0xFD0505EF, 0x0DE301F7);
	r2 = D(r2, s1_0_1, 0xFFFDF608, 0x10F9153B, 0x0A0DF7FA, 0x0BF9F904);
	r3 = D(r3, s1_0_1, 0x17F1FCF5, 0x08B6DDFE, 0xFFE8E4F6, 0x01F50209);
	r0 = D(r0, s1_0_2, 0x0C09FFEF, 0xF20C0EE3, 0x02212DFF, 0xFC01FC0A);
	r1 = D(r1, s1_0_2, 0xF501FA14, 0x05040209, 0xFF0AFD07, 0x0F0C04F3);
	r2 = D(r2, s1_0_2, 0xF8F7FAF4, 0xFAFE01EC, 0xFBFEEE11, 0x050AFD03);
	r3 = D(r3, s1_0_2, 0x010BF3F8, 0x9E816D29, 0x0417F3D6, 0xE6C92ABF);
	r0 = D(r0, s1_1_0, 0x02EEF7B3, 0xF50619FC, 0x12F8F9FD, 0x05F7FF0B);
	r1 = D(r1, s1_1_0, 0xFC0D0300, 0x0CFA0AFE, 0x050BEDF2, 0x100F050B);
	r2 = D(r2, s1_1_0, 0x0C12FDF4, 0xE508000D, 0x0E0AD30C, 0x0905F7FE);
	r3 = D(r3, s1_1_0, 0x0B11DDF7, 0x0DE51F4A, 0x08FA0B0A, 0x0A060EEF);
	r0 = D(r0, s1_1_1, 0x0CE90CFE, 0x0B18DBD0, 0x341CFBF2, 0xFAEA050A);
	r1 = D(r1, s1_1_1, 0xCFBA1334, 0x1423F507, 0x1E480317, 0x0FF82C13);
	r2 = D(r2, s1_1_1, 0xFA27191F, 0xEFEDFFF6, 0xF70A9DF3, 0x03F92525);
	r3 = D(r3, s1_1_1, 0x21FAD6D4, 0x0E2A2BB3, 0xFFDF0C0F, 0x813E271C);
	r0 = D(r0, s1_1_2, 0x10FC020D, 0xF1ED0AF7, 0x20FBF0F6, 0x0A06FE0A);
	r1 = D(r1, s1_1_2, 0xD506F702, 0x0712FFF8, 0x0FFE0403, 0x0CE20104);
	r2 = D(r2, s1_1_2, 0xF8EFFE0B, 0x06F51B10, 0xFF0EBC0A, 0x05FC0014);
	r3 = D(r3, s1_1_2, 0x1807D70F, 0xF90E1F13, 0x19FFF414, 0x8EAE5B8A);
	r0 = D(r0, s1_2_0, 0xE1FF37D4, 0xF50917DE, 0x08FD10F3, 0xFF05F9FA);
	r1 = D(r1, s1_2_0, 0xF50CFDFC, 0x021510FC, 0x06010709, 0x08040503);
	r2 = D(r2, s1_2_0, 0x0401060D, 0x083010EC, 0x10FBE8E7, 0x00FEF7FF);
	r3 = D(r3, s1_2_0, 0x02FDE4F7, 0xFDF6F804, 0x04090400, 0xEE0A0DEE);
	r0 = D(r0, s1_2_1, 0xFE16E8EC, 0xD6F815E2, 0x0D1A0D13, 0x0405070F);
	r1 = D(r1, s1_2_1, 0xFBDE040D, 0x0811EE03, 0x00061520, 0x0B16050E);
	r2 = D(r2, s1_2_1, 0xE9F707E7, 0xD3F80AFF, 0x421ADA08, 0x03030B04);
	r3 = D(r3, s1_2_1, 0x1400EDF1, 0x030C080B, 0xFF0303EF, 0xCDF4FE19);
	r0 = D(r0, s1_2_2, 0x020CF4F8, 0xDC051FFF, 0x0DD3F31E, 0x00FBFF06);
	r1 = D(r1, s1_2_2, 0xE81CFAEA, 0x0C060301, 0xFEF20209, 0x0C00FDF5);
	r2 = D(r2, s1_2_2, 0xFAEA0C08, 0xFB0AF3E0, 0x29E1E01D, 0x01FAFF07);
	r3 = D(r3, s1_2_2, 0x15F5E3FF, 0xF9FBF6F9, 0x070503F7, 0x81C88181);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(3.094e-02, -1.399e-01, 9.908e-03, -2.044e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-3.082e-02, 2.437e-02, -1.950e-02, 5.753e-03);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-3.511e-03, -3.611e-02, -3.870e-02, -1.738e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(1.335e-02, -1.001e-02, -8.886e-03, -3.048e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-BILINEAR-MPV-NVL-conv4
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
	r0 = D(r0, s0_0_0, 0x34D8FA0D, 0x00FAFAFA, 0xF7F5010E, 0x0600FFFD);
	r1 = D(r1, s0_0_0, 0x0E08E404, 0x00F60A02, 0x0507FCF9, 0x0406FD02);
	r2 = D(r2, s0_0_0, 0x06D60F0F, 0xF503FAFE, 0x01FAF90F, 0xEB0004F2);
	r3 = D(r3, s0_0_0, 0x030501FB, 0xF2F40AE1, 0x02FCFEFD, 0x17F9FC0C);
	r0 = D(r0, s0_0_1, 0xD3F41109, 0xF6E50708, 0x02EFFDE9, 0x06FE01ED);
	r1 = D(r1, s0_0_1, 0x09E0ECB7, 0xF8FB1212, 0xF70002EF, 0xFB02FBFF);
	r2 = D(r2, s0_0_1, 0xF6F80981, 0x06F70CFC, 0xE4EA0E32, 0x21F712EA);
	r3 = D(r3, s0_0_1, 0xF6040F0A, 0x14F809F8, 0xF8F713FD, 0xE8ED0309);
	r0 = D(r0, s0_0_2, 0xFD0A09BD, 0xFAF60481, 0x01FA0216, 0x01FE00F2);
	r1 = D(r1, s0_0_2, 0xF4030181, 0x01FF0311, 0xFEFDFE81, 0x09FFFDFD);
	r2 = D(r2, s0_0_2, 0x0CF601F4, 0x09031281, 0x02FC0209, 0xF3CE0BD6);
	r3 = D(r3, s0_0_2, 0xED011381, 0x00FB05F4, 0x04F90E0B, 0x08FC09AF);
	r0 = D(r0, s0_1_0, 0x0FE20DF9, 0x03FC02FE, 0x1CCC0F09, 0xDAFE0FFE);
	r1 = D(r1, s0_1_0, 0xBFAC2417, 0xFBFD2400, 0xE8EA1200, 0xF3FF04FD);
	r2 = D(r2, s0_1_0, 0x08BED02C, 0x0004F2F9, 0xEEE61FFC, 0xFEFCF701);
	r3 = D(r3, s0_1_0, 0xFA090A02, 0x09F20C08, 0x02F205FB, 0xEEEF04F7);
	r0 = D(r0, s0_1_1, 0xE7D90525, 0x18E21B15, 0xE4DD003B, 0xE0F905D1);
	r1 = D(r1, s0_1_1, 0xE5DBED52, 0x27EE320E, 0xF9D425F4, 0xE8F8FFEA);
	r2 = D(r2, s0_1_1, 0xC1F8F681, 0x240129FD, 0xFDE406E8, 0x2AE510F7);
	r3 = D(r3, s0_1_1, 0xE2100A16, 0x1AFA1609, 0x24E53302, 0x0EE6112C);
	r0 = D(r0, s0_1_2, 0x05FF02A3, 0x05E207FB, 0xFBF708DD, 0x01070381);
	r1 = D(r1, s0_1_2, 0xFDCC1181, 0xFCEC1120, 0x12E60BD8, 0x00FF020C);
	r2 = D(r2, s0_1_2, 0x0CF20F06, 0xDDF90E81, 0xFDDA1A26, 0xF1E207EB);
	r3 = D(r3, s0_1_2, 0xBF000487, 0xF400FF04, 0xECFB111C, 0xEECD07DF);
	r0 = D(r0, s0_2_0, 0xCEF0150B, 0xFDFAFE0C, 0xD8EC10F9, 0x0FF41510);
	r1 = D(r1, s0_2_0, 0xFA081101, 0xE4F70AF8, 0x0800FC0A, 0x00FE02FF);
	r2 = D(r2, s0_2_0, 0x22ECF305, 0xFD02ED00, 0x0CFAFFF8, 0x03F9FE02);
	r3 = D(r3, s0_2_0, 0x02FF0A09, 0x09FC0203, 0xF9FFF400, 0xF8FD0307);
	r0 = D(r0, s0_2_1, 0x23E600F0, 0xE5FE0AEA, 0x21F209F5, 0x1DE70B32);
	r1 = D(r1, s0_2_1, 0x0BF519F8, 0x02FD23EE, 0x14FA1418, 0x01FC0BFD);
	r2 = D(r2, s0_2_1, 0xF6FE0B81, 0x08F51204, 0xECF9EF09, 0x10FB0214);
	r3 = D(r3, s0_2_1, 0xC0F2290A, 0xF0010803, 0x18F81806, 0xEAE225E3);
	r0 = D(r0, s0_2_2, 0x05FE048C, 0xF7F80FE3, 0x01E903FA, 0x09FFFF28);
	r1 = D(r1, s0_2_2, 0xF4020581, 0xFEF106F1, 0xFC00FBFA, 0x03FF0101);
	r2 = D(r2, s0_2_2, 0xF4FE07FF, 0x0002F9C4, 0x0106F414, 0xE605FE1A);
	r3 = D(r3, s0_2_2, 0x9D0C355F, 0x04020100, 0xE7FE19AA, 0x16E6FCD6);
	r0 = D(r0, s1_0_0, 0xFB1AE213, 0xFEFC03FE, 0x0AF6FAF0, 0xFC0CFE0A);
	r1 = D(r1, s1_0_0, 0x04C505D9, 0x00FE0205, 0xFBFF0603, 0xFFFC0104);
	r2 = D(r2, s1_0_0, 0xDFD6E01B, 0xFDF606EF, 0x16FDEC1F, 0xF7EC05DB);
	r3 = D(r3, s1_0_0, 0x0205F00C, 0xFBF00916, 0x0206FEFF, 0x0D0FE8FB);
	r0 = D(r0, s1_0_1, 0xEEF30EFF, 0x0302FFF7, 0xF710FA09, 0x0205FEFC);
	r1 = D(r1, s1_0_1, 0xCEA8130E, 0x0200FDFA, 0xFEFC0CFC, 0xF5E50911);
	r2 = D(r2, s1_0_1, 0x0F0FF40B, 0x1215F3FC, 0x0910E1F4, 0xF7FCEC43);
	r3 = D(r3, s1_0_1, 0x0304EE09, 0xFBF200FE, 0xF9F0FDF5, 0xE1F3140D);
	r0 = D(r0, s1_0_2, 0x08FFF702, 0x010300FB, 0xFFFFFD01, 0x01FF0502);
	r1 = D(r1, s1_0_2, 0xFC19EA05, 0xFC01FB04, 0xFF0EFA11, 0xFB03FC09);
	r2 = D(r2, s1_0_2, 0x04FB0DFF, 0xF203FBF6, 0x0FED13FA, 0xF6FF1104);
	r3 = D(r3, s1_0_2, 0x0E0CEB0C, 0xFB000804, 0xFE08F800, 0x070AEE04);
	r0 = D(r0, s1_1_0, 0xCD140B2E, 0xFBF8FEF9, 0xFD05F807, 0xFFDD16E2);
	r1 = D(r1, s1_1_0, 0x59F8DB17, 0xEFF708F3, 0x0CE9FDE5, 0xFCF607F5);
	r2 = D(r2, s1_1_0, 0xF5C8F0E8, 0xF9FA03EB, 0x08FF11D7, 0x0E01FDEB);
	r3 = D(r3, s1_1_0, 0xFDFEE502, 0xFD0AFC37, 0xF6070CF7, 0xE2FD1803);
	r0 = D(r0, s1_1_1, 0x1DEF04F7, 0xFCF9FAF8, 0x2402010E, 0xFBF90720);
	r1 = D(r1, s1_1_1, 0x7DECC024, 0x050707EC, 0x31EAF412, 0x0609112A);
	r2 = D(r2, s1_1_1, 0xEE28B10C, 0x0A17F413, 0xF1DA2DEB, 0xEE040328);
	r3 = D(r3, s1_1_1, 0xFCE3DE02, 0xFDF10FFE, 0x14FFDE2E, 0x5604D0E8);
	r0 = D(r0, s1_1_2, 0xF715D5FD, 0x0B010CFC, 0xF60CF6FF, 0xFF06F305);
	r1 = D(r1, s1_1_2, 0x3EE326E8, 0x05FE0DF8, 0x15EE05F0, 0xFF06EA07);
	r2 = D(r2, s1_1_2, 0x00F41607, 0xF6F0EC4F, 0xFF0505ED, 0xF1F00E17);
	r3 = D(r3, s1_1_2, 0xE810E616, 0xF804F201, 0xF3040513, 0xF40FFE0C);
	r0 = D(r0, s1_2_0, 0x0C0300EE, 0x09FE0004, 0xF5FF0BE5, 0x24F8ED16);
	r1 = D(r1, s1_2_0, 0x03041505, 0x090007EF, 0x0504FB0A, 0xFE010301);
	r2 = D(r2, s1_2_0, 0xE70900FB, 0xFEFD04EF, 0xF5000715, 0xF50205F7);
	r3 = D(r3, s1_2_0, 0x0C00EB22, 0x0001F90A, 0xFB0102FC, 0x11FFF8F4);
	r0 = D(r0, s1_2_1, 0xFA00FEF0, 0x040609FD, 0x0D02F9E9, 0x29FBFECA);
	r1 = D(r1, s1_2_1, 0xECF31107, 0xF4FD0200, 0xFAF706F2, 0xFB050300);
	r2 = D(r2, s1_2_1, 0x0EFEF7FA, 0x0303F6F4, 0x1203F50C, 0x07FDF90F);
	r3 = D(r3, s1_2_1, 0x1D11F016, 0xFFF7FE02, 0xF302FA0D, 0xDD0A0CF9);
	r0 = D(r0, s1_2_2, 0x0106050A, 0x10F9F8FD, 0x06020605, 0x06F506FE);
	r1 = D(r1, s1_2_2, 0xDCFD2411, 0x05FE06FF, 0x03FB0505, 0x07FF0203);
	r2 = D(r2, s1_2_2, 0xF4F908FA, 0x07FDF80E, 0x17F6F90A, 0x01F8FE01);
	r3 = D(r3, s1_2_2, 0x11FBDE0A, 0x0403FC05, 0x09FEF401, 0x2902FFF5);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0x06EC11DC, 0x00FA04FF, 0xFCE20AE0, 0xFD07FA00);
	r1 = D(r1, s0_0_0, 0x00B71CD8, 0x02FFFC01, 0x00010302, 0x01FC01FC);
	r2 = D(r2, s0_0_0, 0x25A9FA16, 0x0D030103, 0xF402D512, 0x0B0BF012);
	r3 = D(r3, s0_0_0, 0x07FCFCFA, 0x02DF0D00, 0xFE06F701, 0xFEFCF6E3);
	r0 = D(r0, s0_0_1, 0x09F0EAF6, 0xFAF20B01, 0xFB000DF9, 0xFE0CED08);
	r1 = D(r1, s0_0_1, 0x1681EDE9, 0xF6FE07F0, 0x01F8EF03, 0xFAEA01F0);
	r2 = D(r2, s0_0_1, 0xE70215E3, 0xE5F60DF2, 0xE4E1E92A, 0xFBABFAE6);
	r3 = D(r3, s0_0_1, 0x060CFEF4, 0x06EFDF14, 0x09DB14F4, 0x06D90BF1);
	r0 = D(r0, s0_0_2, 0xFFFC0DF6, 0x04EDE518, 0xF803F30B, 0xFD03FEFF);
	r1 = D(r1, s0_0_2, 0x06FE13E0, 0xFBFD00F6, 0xF6FC14F3, 0x03FBFEFD);
	r2 = D(r2, s0_0_2, 0xFD090404, 0x0DFADD12, 0xF203D209, 0x10EF130A);
	r3 = D(r3, s0_0_2, 0xF904F600, 0x00FE09FC, 0x00F8EC05, 0xF00AF7F9);
	r0 = D(r0, s0_1_0, 0x100A00E8, 0x03FFFB09, 0x2CF1E3DF, 0x03E81BF6);
	r1 = D(r1, s0_1_0, 0xF9F0D1E6, 0x2505FFFF, 0xFAF912FA, 0x0DFE0000);
	r2 = D(r2, s0_1_0, 0x48F5ED3D, 0x0A030505, 0x1F0A14E6, 0x0A04030C);
	r3 = D(r3, s0_1_0, 0x030000F4, 0xFDF6DB02, 0xF3FD0EF8, 0x21FD00F4);
	r0 = D(r0, s0_1_1, 0x11FA0006, 0x22F4FC16, 0xFFE7D8F8, 0xF3E622EE);
	r1 = D(r1, s0_1_1, 0x08B9AD0C, 0x08EDFB00, 0xECE1E008, 0x51FB00F5);
	r2 = D(r2, s0_1_1, 0xF004E8B5, 0xC5F6F1F1, 0x53FB2AC6, 0xF505000C);
	r3 = D(r3, s0_1_1, 0x201CFB17, 0x01FF1008, 0xFCDDD40D, 0x0EB6D7E6);
	r0 = D(r0, s0_1_2, 0x04FB0FEC, 0x06001BF0, 0xFEFD07F7, 0xFEFE07F1);
	r1 = D(r1, s0_1_2, 0x0AF4CA1C, 0x06FEF4FC, 0x11ECF606, 0xF2FEFCFA);
	r2 = D(r2, s0_1_2, 0x0202050F, 0x30FB07F5, 0x2F00FEDD, 0x0200E5F4);
	r3 = D(r3, s0_1_2, 0x39EB1214, 0x01FFF5FB, 0x12F112EE, 0xF4ECEBF3);
	r0 = D(r0, s0_2_0, 0x0D0B0FF6, 0x06FEFD05, 0x0706FD05, 0x01F8DF11);
	r1 = D(r1, s0_2_0, 0x18FE19EB, 0x0C0501FF, 0x01FE0A01, 0x01FEFD02);
	r2 = D(r2, s0_2_0, 0xF600F80B, 0x07FE0702, 0xF201E400, 0xFA050506);
	r3 = D(r3, s0_2_0, 0x0503FB02, 0xF4030907, 0x02FF03FF, 0xF6FA0305);
	r0 = D(r0, s0_2_1, 0x09FA0AF1, 0x0BFBEFFD, 0x04FF14F2, 0x11EC10FE);
	r1 = D(r1, s0_2_1, 0xF9F81A03, 0x0F0104F3, 0x070829F4, 0x04FEFC01);
	r2 = D(r2, s0_2_1, 0x0B0707F4, 0xE7FD0400, 0xF7FAEC06, 0xF003FC05);
	r3 = D(r3, s0_2_1, 0x0B05FE02, 0xFFFDF404, 0xFB020505, 0x0C0DFEF2);
	r0 = D(r0, s0_2_2, 0xFB000701, 0x07FCFC01, 0x00FF02F7, 0x01FD0300);
	r1 = D(r1, s0_2_2, 0x100907F4, 0x020200FE, 0x0102FCFD, 0xFD000300);
	r2 = D(r2, s0_2_2, 0xF8040108, 0x08010A03, 0xEAFFFB18, 0x03FE0007);
	r3 = D(r3, s0_2_2, 0x1301F4EA, 0xFEFF0100, 0x08FDF3FF, 0x0DFC08EA);
	r0 = D(r0, s1_0_0, 0x1DEBFDE0, 0x50FB0405, 0x0E050A00, 0x0C07FBFF);
	r1 = D(r1, s1_0_0, 0xF2F715F8, 0xDBFF00FF, 0x21010200, 0xB20101FC);
	r2 = D(r2, s1_0_0, 0x1E0400FC, 0xDFFBFEFE, 0x2800FC0E, 0xEFFC0101);
	r3 = D(r3, s1_0_0, 0xF4FCFC00, 0xE7FE0405, 0xF50403FF, 0xF80005F1);
	r0 = D(r0, s1_0_1, 0xFB041608, 0x08FB0100, 0xFCE7010C, 0xFC0700FC);
	r1 = D(r1, s1_0_1, 0xF20FF6EE, 0xF0FDFEFC, 0xF9F4FF07, 0x0105050C);
	r2 = D(r2, s1_0_1, 0xEFFD1410, 0x18FDFC00, 0x1703F8F0, 0x51F6F8FE);
	r3 = D(r3, s1_0_1, 0xF806FDF5, 0x0DFAF7FC, 0xED040201, 0xEFEE0A1A);
	r0 = D(r0, s1_0_2, 0xFEFEF206, 0x01F0FFFF, 0xFF0EFA03, 0x0003FE03);
	r1 = D(r1, s1_0_2, 0xFEE60B0B, 0xFE020208, 0xFE03FC06, 0x0102FA06);
	r2 = D(r2, s1_0_2, 0xFF0CF9F5, 0x2000040A, 0x03080C0E, 0xF30E1303);
	r3 = D(r3, s1_0_2, 0xF80C0400, 0xFF070C07, 0xFAFEFF07, 0xFC0CF602);
	r0 = D(r0, s1_1_0, 0xCA1FD9B8, 0xF0FD0301, 0x05D70BD5, 0x660BFDFE);
	r1 = D(r1, s1_1_0, 0x81C91501, 0x7FF7FCEE, 0x910BFEFE, 0x7F04FBFD);
	r2 = D(r2, s1_1_0, 0x01C810A8, 0xD1FCFFFF, 0x31F202EB, 0x23FB04FF);
	r3 = D(r3, s1_1_0, 0x630708F0, 0x0EFDEAF9, 0x8110FAFA, 0x0AF7F8DE);
	r0 = D(r0, s1_1_1, 0xF8EE24F8, 0x18CD03E4, 0xED0A2701, 0x030CFC09);
	r1 = D(r1, s1_1_1, 0x31C84681, 0x2AF405EE, 0x0C25FEEA, 0x2512F8ED);
	r2 = D(r2, s1_1_1, 0x01193817, 0x7F1AE218, 0x09DE0C86, 0x25D9BED0);
	r3 = D(r3, s1_1_1, 0x7FFB0704, 0x07FF07EE, 0x69ED0308, 0xFAE12CD7);
	r0 = D(r0, s1_1_2, 0x05F7F80F, 0x04F214FD, 0xFFFDCD01, 0xFF04FAFD);
	r1 = D(r1, s1_1_2, 0x0ACA33FC, 0x04FE12FD, 0x0701EEF6, 0x0602FA0E);
	r2 = D(r2, s1_1_2, 0xFB1FC1FC, 0x26F416E1, 0x00CB46E6, 0xE927430E);
	r3 = D(r3, s1_1_2, 0x01FAE201, 0xFE081C07, 0xE7200F09, 0xEFFBEA0C);
	r0 = D(r0, s1_2_0, 0xBBF081F3, 0xD9FA8109, 0x180BEE06, 0xE4EBD1EB);
	r1 = D(r1, s1_2_0, 0xE20E810B, 0x40F9F101, 0x23FA3CE9, 0x05050203);
	r2 = D(r2, s1_2_0, 0x21158100, 0x14FAFAFF, 0x23151A04, 0xEC05F9F4);
	r3 = D(r3, s1_2_0, 0x23F58700, 0xE2028AFC, 0x1904EFF6, 0xEEFA0814);
	r0 = D(r0, s1_2_1, 0x0DF5BCE9, 0xE9FDC20F, 0x0DF102EC, 0x05DBB1D7);
	r1 = D(r1, s1_2_1, 0xF20E1201, 0xFC0029F8, 0xFBEF54D7, 0x0B000200);
	r2 = D(r2, s1_2_1, 0xEDFEA40F, 0x810F170B, 0xE8029E1B, 0xF408DC09);
	r3 = D(r3, s1_2_1, 0xEEF1C2FE, 0x0201E207, 0x0405C600, 0x141FF0E1);
	r0 = D(r0, s1_2_2, 0x06FA0212, 0xFFF1000D, 0x05FAD504, 0x030281F8);
	r1 = D(r1, s1_2_2, 0x011C3FF0, 0xF9F8F405, 0xFDED1B03, 0x00FB0504);
	r2 = D(r2, s1_2_2, 0xFD06E8F9, 0x1EDFBF05, 0x03EF2B1D, 0xFCFCD7FF);
	r3 = D(r3, s1_2_2, 0xFA0A3109, 0xFD050503, 0xFA08DF0B, 0x0CE5DAEC);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-1.838e-02, -1.805e-02, -1.984e-02, -1.309e-02);
	f0 = max(f0, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), f0);
	f1 = vec4(r1) * 6.2000124e-05;
	f1 += vec4(-8.215e-02, -9.424e-03, -1.811e-02, 3.889e-02);
	f1 = max(f1, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), f1);
	f2 = vec4(r2) * 6.2000124e-05;
	f2 += vec4(-4.021e-02, -5.130e-03, -4.191e-02, -1.910e-02);
	f2 = max(f2, vec4(0.0));
	imageStore(out_image, opos + ivec2(0, 1), f2);
	f3 = vec4(r3) * 6.2000124e-05;
	f3 += vec4(-3.571e-02, -5.110e-03, -5.231e-03, -2.611e-02);
	f3 = max(f3, vec4(0.0));
	imageStore(out_image, opos + ivec2(1, 1), f3);
}

//!DESC CuNNy-4x16-BILINEAR-MPV-NVL-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv4
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
	r0 = D(r0, s0_0_0, 0xFF050702, 0xFE020001, 0x02FEFF03, 0xFEFCFF00);
	r0 = D(r0, s0_0_1, 0x1ED018EF, 0x0B0C1802, 0xD0070102, 0xF7FBFFFC);
	r0 = D(r0, s0_0_2, 0x0A0EFE06, 0x1D06040C, 0xF7FC00FF, 0xD30E0108);
	r0 = D(r0, s0_1_0, 0x0101F301, 0x00000AFF, 0xFF031600, 0xFF010A00);
	r0 = D(r0, s0_1_1, 0xFB18F2FE, 0xFEFBD70E, 0x1003FBE4, 0x0A100E11);
	r0 = D(r0, s0_1_2, 0x01F2FF0E, 0xFE1103E0, 0x010F010F, 0x07CFFCF2);
	r0 = D(r0, s0_2_0, 0x00000200, 0x00000000, 0x00FFF5FF, 0x0000FB00);
	r0 = D(r0, s0_2_1, 0x00FE0201, 0x000002FF, 0x00FEFB09, 0x00FFF702);
	r0 = D(r0, s0_2_2, 0x00FFFFFE, 0x00000100, 0x00020107, 0x0009FDF5);
	r0 = D(r0, s1_0_0, 0xFCFAF7FD, 0xFD0300FC, 0xFE04FD02, 0x01FF0103);
	r0 = D(r0, s1_0_1, 0x03D61003, 0x03D8F404, 0xFA0C0FFD, 0xFB1001FE);
	r0 = D(r0, s1_0_2, 0xFE0504FF, 0xFDF81300, 0x02FFFE02, 0xFE000701);
	r0 = D(r0, s1_1_0, 0x02020006, 0xFAFE0100, 0x01FDF6F9, 0xF9FE0201);
	r0 = D(r0, s1_1_1, 0x1DFFE81D, 0x1D05EA16, 0x1F19E7EC, 0x1E0ED4EB);
	r0 = D(r0, s1_1_2, 0xFDFFFE04, 0x05FDFC11, 0xFCFF07FA, 0x070A0DF2);
	r0 = D(r0, s1_2_0, 0xFF00FFFF, 0x02000000, 0xFDFF03FD, 0xFE0000FF);
	r0 = D(r0, s1_2_1, 0xFBFF02FD, 0xFBFF00FF, 0x03FFFD04, 0x04FD02FD);
	r0 = D(r0, s1_2_2, 0x010001FE, 0xFE0003FC, 0xFE00FE02, 0xFD01FD05);
	s0_0_0 = G[2][xy.y+0][xy.x+0]; s0_0_1 = G[2][xy.y+0][xy.x+1];
	s0_0_2 = G[2][xy.y+0][xy.x+2]; s0_1_0 = G[2][xy.y+1][xy.x+0];
	s0_1_1 = G[2][xy.y+1][xy.x+1]; s0_1_2 = G[2][xy.y+1][xy.x+2];
	s0_2_0 = G[2][xy.y+2][xy.x+0]; s0_2_1 = G[2][xy.y+2][xy.x+1];
	s0_2_2 = G[2][xy.y+2][xy.x+2]; s1_0_0 = G[3][xy.y+0][xy.x+0];
	s1_0_1 = G[3][xy.y+0][xy.x+1]; s1_0_2 = G[3][xy.y+0][xy.x+2];
	s1_1_0 = G[3][xy.y+1][xy.x+0]; s1_1_1 = G[3][xy.y+1][xy.x+1];
	s1_1_2 = G[3][xy.y+1][xy.x+2]; s1_2_0 = G[3][xy.y+2][xy.x+0];
	s1_2_1 = G[3][xy.y+2][xy.x+1]; s1_2_2 = G[3][xy.y+2][xy.x+2];
	r0 = D(r0, s0_0_0, 0xFD04F300, 0x01030E00, 0x01FCFB00, 0x01FEFE00);
	r0 = D(r0, s0_0_1, 0x03FC00FF, 0xFE02FDFD, 0x02FAFE00, 0xFDFCFFFE);
	r0 = D(r0, s0_0_2, 0x000100FE, 0x04FDFF0F, 0x00010000, 0x00FE0001);
	r0 = D(r0, s0_1_0, 0x13F5EDFF, 0xFF030C00, 0x0A06E3FF, 0xFA002600);
	r0 = D(r0, s0_1_1, 0x25E80006, 0xC7DFFDFA, 0x062A01FD, 0xED1EFBFB);
	r0 = D(r0, s0_1_2, 0xFC0000E0, 0x0BFD001D, 0xFFFF01DF, 0x0A0F002E);
	r0 = D(r0, s0_2_0, 0x000102FF, 0x01010000, 0x0101FDFE, 0x0200FB00);
	r0 = D(r0, s0_2_1, 0x0101FFFF, 0xFC020100, 0x1FFE0003, 0xE804FFFE);
	r0 = D(r0, s0_2_2, 0xFF0100FF, 0x03000101, 0xFFFF01FB, 0x01FA0004);
	r0 = D(r0, s1_0_0, 0x00120121, 0x03FD0015, 0xF8020014, 0xFC01000C);
	r0 = D(r0, s1_0_1, 0x19E30208, 0xD3010414, 0x08FDFE07, 0x0DFBFF10);
	r0 = D(r0, s1_0_2, 0xFC00F900, 0x09F4F801, 0x01FF0200, 0xFCFD0601);
	r0 = D(r0, s1_1_0, 0xFC090207, 0x00FCFF06, 0x0B1C030F, 0x00FDFF0D);
	r0 = D(r0, s1_1_1, 0x0DFBC904, 0x100B0B06, 0xD4E6EB05, 0x13F21504);
	r0 = D(r0, s1_1_2, 0xFF001300, 0xF9F7FB01, 0x01FE08FF, 0x08F9D801);
	r0 = D(r0, s1_2_0, 0xFFFF0001, 0x00010201, 0x00000004, 0xFFFE0203);
	r0 = D(r0, s1_2_1, 0xFFFF0600, 0xFFFCF8FF, 0x05FCED01, 0xFC05F901);
	r0 = D(r0, s1_2_2, 0xFD000000, 0xFEFF0500, 0x05FF0900, 0xFF020A00);
	f0 = vec4(r0) * 6.2000124e-05;
	f0 += vec4(-6.363e-03, -6.639e-03, -6.669e-03, -7.886e-03);
	f0 = tanh(f0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(f0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(f0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(f0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(f0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}
