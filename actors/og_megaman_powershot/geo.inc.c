const GeoLayout og_megaman_powershot_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_SCALE(LAYER_FORCE, 32768),
		GEO_OPEN_NODE(),
			GEO_ASM(LAYER_OPAQUE << 2, geo_mirror_mario_backface_culling),
			GEO_ASM(0, geo_mirror_mario_set_alpha),
			GEO_ASM((LAYER_OPAQUE << 2) | 1, geo_mirror_mario_backface_culling),
			GEO_DISPLAY_LIST(LAYER_OPAQUE, og_megaman_powershot_Shot_2_DL_mesh_layer_1),
		GEO_CLOSE_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, og_megaman_powershot_material_revert_render_settings),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
