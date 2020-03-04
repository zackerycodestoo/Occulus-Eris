/obj/item/device/scanner/mining
	name = "subsurface ore detector"
	desc = "A complex device used to locate ore deep underground."
	icon_state = "mining-scanner"
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_STEEL = 1, MATERIAL_GLASS = 1)

	charge_per_use = 2

/obj/item/device/scanner/mining/is_valid_scan_target(atom/O)
	return istype(O, /turf/simulated)


/obj/item/device/scanner/mining/scan(turf/T, mob/user)
	scan_data = mining_scan_action(T, user)
	scan_title = "Subsurface ore scan - ([T.x], [T.y])"
	show_results(user)

/proc/mining_scan_action(turf/source, mob/user)
	var/list/metals = list(
		"surface minerals" = 0,
		"precious metals" = 0,
		"nuclear fuel" = 0,
		"exotic matter" = 0
		)

	var/list/lines = list("Ore deposits found at [source.x], [source.y]:")

	for(var/turf/simulated/T in trange(2, source))
		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type

			switch(metal)
				if("silicates", "carbonaceous rock", "iron")
					ore_type = "surface minerals"
				if(MATERIAL_GOLD, MATERIAL_SILVER, MATERIAL_DIAMOND)
					ore_type = "precious metals"
				if(MATERIAL_URANIUM)
					ore_type = "nuclear fuel"
				if("phoron", "osmium", "hydrogen")
					ore_type = "exotic matter"

			if(ore_type)
				metals[ore_type] += T.resources[metal]

	for(var/ore_type in metals)
		var/result = "no sign"

		switch(metals[ore_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "significant amounts"
			if(76 to INFINITY) result = "huge quantities"

		lines += "- [result] of [ore_type]."

	return jointext(lines, "<br>")
