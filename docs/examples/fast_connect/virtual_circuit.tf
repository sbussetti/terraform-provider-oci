resource "oci_core_drg" "test_drg_private" {
	#Required
	compartment_id = "${var.compartment_id}"
}

resource "oci_core_virtual_circuit" "test_virtual_circuit_private" {
	#Required
	compartment_id = "${var.compartment_id}"
	type = "${var.virtual_circuit_type_private}"

	#Required for PRIVATE VirtualCircuit
	bandwidth_shape_name = "${var.virtual_circuit_bandwidth_shape_name}"
	cross_connect_mappings {
		cross_connect_or_cross_connect_group_id = "${oci_core_cross_connect.test_cross_connect.cross_connect_group_id}"
		customer_bgp_peering_ip = "${var.virtual_circuit_cross_connect_mappings_customer_bgp_peering_ip}"
		oracle_bgp_peering_ip = "${var.virtual_circuit_cross_connect_mappings_oracle_bgp_peering_ip}"
		vlan = "${var.virtual_circuit_cross_connect_mappings_vlan}"
	}
	customer_bgp_asn = "${var.virtual_circuit_customer_bgp_asn}"
	display_name = "${var.virtual_circuit_display_name}"
	gateway_id = "${oci_core_drg.test_drg_private.id}"
	#provider_service_id = "${oci_core_provider_service.test_provider_service.id}"
	region = "${var.virtual_circuit_region}"
}
resource "oci_core_virtual_circuit" "test_virtual_circuit_public" {
	#Required
	compartment_id = "${var.compartment_id}"
	type = "${var.virtual_circuit_type_public}"

	#Required for PUBLIC Virtual Circuit
	bandwidth_shape_name = "${var.virtual_circuit_bandwidth_shape_name}"
	cross_connect_mappings {
		cross_connect_or_cross_connect_group_id = "${oci_core_cross_connect.test_cross_connect.cross_connect_group_id}"
		vlan = "${var.virtual_circuit_cross_connect_mappings_vlan_public}"
	}
	customer_bgp_asn = "${var.virtual_circuit_customer_bgp_asn}"
	display_name = "${var.virtual_circuit_display_name}"
	#provider_service_id = "${oci_core_provider_service.test_provider_service.id}"
	public_prefixes = [
		#Required
		{
			cidr_block = "${var.virtual_circuit_public_prefixes_cidr_block}"
		},
		{
			cidr_block = "${var.virtual_circuit_public_prefixes_cidr_block2}"
		},
	]
	region = "${var.virtual_circuit_region}"
}

resource "oci_core_drg" "test_drg_provider_layer2" {
	#Required
	compartment_id = "${var.compartment_id}"
}

resource "oci_core_virtual_circuit" "test_virtual_circuit_provider_layer2" {
	#Required
	compartment_id = "${var.compartment_id}"
	type = "${var.virtual_circuit_type_private}"

	#Required for PRIVATE VirtualCircuit with Provider
	bandwidth_shape_name = "${var.virtual_circuit_bandwidth_shape_name}"
	cross_connect_mappings {
		customer_bgp_peering_ip = "${var.virtual_circuit_cross_connect_mappings_customer_bgp_peering_ip}"
		oracle_bgp_peering_ip = "${var.virtual_circuit_cross_connect_mappings_oracle_bgp_peering_ip}"
	}
	customer_bgp_asn = "${var.virtual_circuit_customer_bgp_asn}"
	display_name = "${var.virtual_circuit_display_name}"
	gateway_id = "${oci_core_drg.test_drg_provider_layer2.id}"
	provider_service_id = "${data.oci_core_fast_connect_provider_services.test_fast_connect_provider_services_private_layer2.fast_connect_provider_services.0.id}"
	region = "${var.virtual_circuit_region}"
}

resource "oci_core_virtual_circuit" "test_virtual_circuit_provider_layer3" {
	#Required
	compartment_id = "${var.compartment_id}"
	type = "${var.virtual_circuit_type_public}"

	#Required for PRIVATE VirtualCircuit with Provider
	bandwidth_shape_name = "${var.virtual_circuit_bandwidth_shape_name}"
	display_name = "${var.virtual_circuit_display_name}"
	provider_service_id = "${data.oci_core_fast_connect_provider_services.test_fast_connect_provider_services_layer3.fast_connect_provider_services.0.id}"
	region = "${var.virtual_circuit_region}"
}

data "oci_core_virtual_circuits" "test_virtual_circuits" {
	#Required
	compartment_id = "${var.compartment_id}"

	#Optional
	display_name = "${var.virtual_circuit_display_name}"
	state = "${var.virtual_circuit_state}"
}

output "virtual_circuits" {
	value = "${data.oci_core_virtual_circuits.test_virtual_circuits.virtual_circuits}"
}

data "oci_core_virtual_circuit" "test_virtual_circuit" {
	virtual_circuit_id = "${oci_core_virtual_circuit.test_virtual_circuit_public.id}"
}

output "virtual_circuit" {
	value = {
		id = "${data.oci_core_virtual_circuit.test_virtual_circuit.id}",
		state = "${data.oci_core_virtual_circuit.test_virtual_circuit.state}",
		type = "${data.oci_core_virtual_circuit.test_virtual_circuit.type}",
	}
}
