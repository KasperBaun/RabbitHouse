module roof() {
    color(col_roof)
    polyhedron(
        points = [
            [-roof_overhang_side, -roof_overhang_front, base_height + shed_height + roof_thickness],
            [shed_length + roof_overhang_side, -roof_overhang_front, base_height + shed_height + roof_thickness],
            [shed_length + roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back + roof_thickness],
            [-roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back + roof_thickness],

            [-roof_overhang_side, -roof_overhang_front, base_height + shed_height],
            [shed_length + roof_overhang_side, -roof_overhang_front, base_height + shed_height],
            [shed_length + roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back],
            [-roof_overhang_side, shed_width + roof_overhang_back, base_height + shed_height - roof_drop_back]
        ],
        faces = [
            [0,1,2,3],
            [4,7,6,5],
            [0,4,5,1],
            [1,5,6,2],
            [2,6,7,3],
            [3,7,4,0]
        ]
    );
}
