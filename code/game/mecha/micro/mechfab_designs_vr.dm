/* //CHOMPedit commented micromech stuff, because fuck this trash
/datum/design/item/mechfab/gopher
	category = list("Gopher")
	time = 5

/datum/design/item/mechfab/gopher/chassis
	name = "Gopher Chassis"
	id = "gopher_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/gopher
	time = 3
	materials = list(MAT_STEEL = 7000)

/datum/design/item/mechfab/gopher/torso
	name = "Gopher Torso"
	id = "gopher_torso"
	build_path = /obj/item/mecha_parts/micro/part/gopher_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/item/mechfab/gopher/left_arm
	name = "Gopher Left Arm"
	id = "gopher_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/gopher/right_arm
	name = "Gopher Right Arm"
	id = "gopher_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_arm

	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/gopher/left_leg
	name = "Gopher Left Leg"
	id = "gopher_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/gopher/right_leg
	name = "Gopher Right Leg"
	id = "gopher_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mecha/drill/micro
	name = "Micro Drill" //CHOMPedit
	id = "micro_drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/micro
	time = 5
	materials = list(MAT_STEEL = 2500)

/datum/design/item/mecha/hydraulic_clamp/micro
	name = "Mounted micro ore box" //CHOMPedit
	id = "ore_scoop"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/micro/orescoop
	time = 5
	materials = list(MAT_STEEL = 2500)

/datum/design/item/mechfab/polecat
	category = list("Polecat")
	time = 10

/datum/design/item/mechfab/polecat/chassis
	name = "Polecat Chassis"
	id = "polecat_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/polecat
	time = 3
	materials = list(MAT_STEEL = 7000)

/datum/design/item/mechfab/polecat/torso
	name = "Polecat Torso"
	id = "polecat_torso"
	build_path = /obj/item/mecha_parts/micro/part/polecat_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/item/mechfab/polecat/left_arm
	name = "Polecat Left Arm"
	id = "polecat_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/polecat/right_arm
	name = "Polecat Right Arm"
	id = "polecat_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/polecat/left_leg
	name = "Polecat Left Leg"
	id = "polecat_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/polecat/right_leg
	name = "Polecat Right Leg"
	id = "polecat_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/polecat/armour
	name = "Polecat Armour Plates"
	id = "polecat_armour"
	build_path = /obj/item/mecha_parts/micro/part/polecat_armour
	time = 25
	materials = list(MAT_STEEL = 12500, MAT_PLASTIC = 7500)

/datum/design/item/mecha/taser/micro
	name = "\improper TS-12 \"Suppressor\" integrated micro taser" //CHOMPedit
	id = "micro_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/microtaser

/datum/design/item/mecha/weapon/laser/micro
	name = "\improper WS-19 \"Torch\" micro laser carbine" //CHOMPedit
	id = "micro_laser"
//	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/microlaser

/datum/design/item/mecha/weapon/laser_heavy/micro
	name = "\improper PC-20 \"Lance\" micro laser cannon" //CHOMPedit
	id = "micro_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/microheavy

/datum/design/item/mecha/weapon/grenade_launcher/micro
	name = "\improper FP-20 mounted micro flashbang launcher" //CHOMPedit
	id = "micro_flashbang_launcher"
//	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/microflashbang

/datum/design/item/mecha/weapon/scattershot/micro
	name = "\improper Remington C-12 \"Micro-Boomstick\"" //CHOMPedit
	desc = "A mounted combat shotgun with integrated ammo-lathe."
	id = "micro_scattershot"
//	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/microshotgun

/datum/design/item/mechfab/weasel
	category = list("Weasel")
	time = 5

/datum/design/item/mechfab/weasel/chassis
	name = "Weasel Chassis"
	id = "weasel_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/weasel
	time = 3
	materials = list(MAT_STEEL = 7000)

/datum/design/item/mechfab/weasel/torso
	name = "Weasel Torso"
	id = "weasel_torso"
	build_path = /obj/item/mecha_parts/micro/part/weasel_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/item/mechfab/weasel/left_arm
	name = "Weasel Left Arm"
	id = "weasel_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/weasel/right_arm
	name = "Weasel Right Arm"
	id = "weasel_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/weasel/left_leg
	name = "Weasel Left Leg"
	id = "weasel_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/weasel/right_leg
	name = "Weasel Right Leg"
	id = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/weasel/tri_leg
	name = "Weasel Tri Leg"
	id = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_tri_leg
	materials = list(MAT_STEEL = 27500)

/datum/design/item/mechfab/weasel/head
	name = "Weasel Head"
	id = "weasel_head"
	build_path = /obj/item/mecha_parts/micro/part/weasel_head
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2500)
*/
