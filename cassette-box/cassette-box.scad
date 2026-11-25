// one-piece compact-cassette case. export "flat" for printing.
// dimensions are millimeters. see README.md before printing the PLA hinges.

/* [view] */
layout = "flat"; // [flat, closed, hinge_test, hinge_test_flat]
show_cassette = false;

/* [cassette envelope] */
cassette_length = 101.6;
cassette_depth = 64;
cassette_thickness = 12.7;
clearance_xy = 0.6;
clearance_z = 0.8;

/* [shell] */
panel = 1.2;
wall = 1.2;
closure_gap = 0.25;

/* [living hinges] */
hinge_thickness = 0.4;
// flexible distance across each hinge, not its length along the spine.
hinge_length = 4;
// keep this at or above `wall` so the web meets the side walls with no dust gap.
hinge_end_inset = 1.2;
// each hinge end ramps from panel thickness up to this length before going thin,
// instead of stepping straight down to hinge_thickness.
hinge_taper = 1;

/* [lid fit] */
skirt_thickness = 1.2;
skirt_depth = 4;
skirt_clearance = 0.25;
// tighter fit for the two end skirts only; keeps them from rattling side to
// side. much snugger than skirt_clearance, but still a positive slip fit -
// most of the rattle beyond the nominal gap is print-tolerance stack-up, so
// also check your slicer's horizontal expansion/elephant-foot compensation.
skirt_clearance_side = 0.05;
skirt_rear_setback = 4;
// retention lip on the long edge opposite the hinge.
lip_interference = 0.2; // [0.05:0.05:0.5]
// retention lip on the two narrow end edges; these take the strain since the
// hinge already restrains the opposite long edge.
lip_interference_side = 0.4; // [0.1:0.05:0.8]
pull_tab_enabled = false;
pull_extension = 3;

/* [single rectangular hub lock] */
hub_lock_enabled = true;
// provisional blade span across opposing tooth gaps; tune to your cassette.
hub_lock_span = 9; // [7:0.1:12]
hub_lock_thickness = 1.6; // [0.8:0.1:3.2]
hub_lock_height = 8; // [4:0.2:10]
hub_lock_tip_chamfer = 0.6; // [0:0.1:1]
// zero degrees puts the long side parallel to the cassette's long edge.
hub_lock_angle = 90; // [0:5:175]
// provisional measurements from the cassette's left and non-tape edges.
// hub_lock_y is biased away from the hinge edge so the same lock position
// works with the cassette inserted either direction.
hub_lock_x = 29; // [24:0.1:34]
hub_lock_y = 33.8; // [25:0.1:36]

/* [lettering] */
// installed font family and style; choose one from OpenSCAD's font list.
text_font = "Liberation Sans:style=Bold";
// engraving depth or raised height, measured from the exterior surface.
text_relief = 0.4; // [0.2:0.2:1]

/* [front lettering - lid] */
front_text = "";
front_text_mode = "engraved"; // [engraved, raised, off]
// font size in millimeters.
front_text_size = 8; // [2:0.5:18]
front_text_rotation = 0; // [0:90:270]
front_text_x = 0; // [-45:0.5:45]
front_text_y = 0; // [-25:0.5:25]

/* [back lettering - base] */
back_text = "";
back_text_mode = "engraved"; // [engraved, raised, off]
// font size in millimeters.
back_text_size = 8; // [2:0.5:18]
back_text_rotation = 0; // [0:90:270]
back_text_x = 0; // [-45:0.5:45]
back_text_y = 0; // [-25:0.5:25]

/* [edge lettering - spine] */
spine_text = "";
// optional right-hand label; when set, the main spine label moves to the left.
spine_text_right = "";
spine_text_mode = "engraved"; // [engraved, raised, off]
// font size in millimeters.
spine_text_size = 4; // [2:0.5:12]
spine_text_rotation = 0; // [0:90:270]
spine_text_x = 0; // [-45:0.5:45]
spine_text_y = 0; // [-4:0.5:4]

/* [Hidden] */
$fn = 64;
eps = 0.01;
w = cassette_length + 2 * (clearance_xy + wall);
d = cassette_depth + 2 * (clearance_xy + wall);
wall_top = panel + cassette_thickness + clearance_z;
lid_inner_z = wall_top + closure_gap;
closed_height = lid_inner_z + panel;
neutral_z = hinge_thickness / 2;
// each 90-degree bend consumes a quarter-circle of the flat web.
bend_r = 2 * hinge_length / PI;
spine_length = closed_height - hinge_thickness - 2 * bend_r;
fold_span = 2 * hinge_length + spine_length;
hinge_width = w - 2 * hinge_end_inset;
skirt_outer = skirt_clearance + skirt_thickness;
skirt_outer_side = skirt_clearance_side + skirt_thickness;
pull_projection = pull_tab_enabled ? pull_extension : 0;
lip_projection = skirt_clearance + lip_interference;
lip_projection_side = skirt_clearance_side + lip_interference_side;
lip_z = panel + skirt_depth - 1;
groove_z = closed_height - lip_z;
rear_extension = max(0, bend_r - (panel - neutral_z) - closure_gap);
lock_half_x = (abs(cos(hub_lock_angle)) * hub_lock_span +
               abs(sin(hub_lock_angle)) * hub_lock_thickness) / 2;
lock_half_y = (abs(sin(hub_lock_angle)) * hub_lock_span +
               abs(cos(hub_lock_angle)) * hub_lock_thickness) / 2;

assert(layout == "flat" || layout == "closed" ||
       layout == "hinge_test" || layout == "hinge_test_flat",
       "choose flat, closed, hinge_test, or hinge_test_flat.");
assert(min(cassette_length, cassette_depth, cassette_thickness,
           clearance_xy, clearance_z, panel, wall, closure_gap,
           hinge_thickness, hinge_length, skirt_thickness, skirt_clearance) > 0,
       "shell, cassette, hinge and clearance dimensions must be positive.");
assert(hinge_thickness < panel && spine_length > panel,
       "hinges must be thinner than panels; reduce hinge_length for this depth.");
assert(hinge_end_inset >= wall && hinge_width > 0,
       "hinge_end_inset must reach the side walls (>= wall) with a positive hinge width.");
assert(hinge_taper >= 0 && 2 * hinge_taper < hinge_length,
       "hinge_taper must leave a positive thin flex zone in the middle of the hinge.");
assert(skirt_clearance_side > -skirt_thickness,
       "skirt_clearance_side must leave positive material in the end skirts.");
assert(skirt_rear_setback > rear_extension && skirt_rear_setback < d,
       "keep the lid skirt clear of the spine.");
assert(lip_interference > 0 && lip_interference + 0.15 < wall &&
       lip_interference_side > 0 && lip_interference_side + 0.15 < wall,
       "lips need positive interference and material behind their grooves.");
assert(skirt_depth > 1 + max(lip_projection, lip_projection_side) &&
       groove_z - max(lip_interference, lip_interference_side) - 0.15 > panel &&
       groove_z + max(lip_interference, lip_interference_side) + 0.15 < wall_top,
       "lips and grooves must fit within the skirt and base walls.");
assert(!pull_tab_enabled || pull_extension > 0,
       "enabled pull tab must have a positive extension.");
assert(!hub_lock_enabled ||
       (min(hub_lock_span, hub_lock_thickness, hub_lock_height) > 0 &&
        hub_lock_height < cassette_thickness &&
        hub_lock_tip_chamfer >= 0 &&
        hub_lock_tip_chamfer < min(hub_lock_span, hub_lock_thickness) / 2 &&
        hub_lock_tip_chamfer < hub_lock_height &&
        hub_lock_x > lock_half_x &&
        hub_lock_x < cassette_length - lock_half_x &&
        hub_lock_y > lock_half_y &&
        hub_lock_y < cassette_depth - lock_half_y),
       "keep the lock inside the cassette; chamfer must leave a positive tip.");

echo(print_footprint = [w + 2 * skirt_outer_side,
     2 * d + fold_span + skirt_outer + pull_projection],
     nominal_closed_size = [w + 2 * skirt_outer_side,
     d + skirt_outer + pull_projection + bend_r + neutral_z, closed_height],
     hinge_radius = bend_r, straight_spine = spine_length);

// extrude a Y/Z profile along X without changing its handedness.
module yz_prism(points, length) {
    multmatrix([[0, 0, 1, 0], [1, 0, 0, 0],
                [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(height = length) polygon(points);
}

// extrude an X/Z profile along Y.
module xz_prism(points, length) {
    translate([0, length, 0])
        rotate([90, 0, 0])
            linear_extrude(height = length) polygon(points);
}

module exterior_label(value, mode, size, angle, offset_x, offset_y,
                      face_depth, flip_y = true, right_value = "") {
    assert(mode == "engraved" || mode == "raised" || mode == "off",
           "text mode must be engraved, raised, or off.");
    if ((value != "" || right_value != "") && mode != "off") {
        assert(size > 0 && text_relief > 0 && w > 2 && face_depth > 2,
               "lettering needs positive size, relief and usable face area.");
        assert(mode != "engraved" || panel - text_relief >= 0.4 - 0.000001,
               "engraving must leave at least 0.4 mm of panel thickness.");
        assert(angle == 0 || angle == 90 || angle == 180 || angle == 270,
               "text rotation must be 0, 90, 180, or 270 degrees.");
        echo("lettering is clipped 1 mm inside its face; check size and position.",
             face_text = value, right_text = right_value);
        if (mode == "raised")
            echo("WARNING: raised exterior lettering projects below the flat print; review bed contact and supports.");
    }
    difference() {
        union() {
            children();
            if ((value != "" || right_value != "") && mode == "raised")
                label_shape(true);
        }
        if ((value != "" || right_value != "") && mode == "engraved")
            label_shape(false);
    }

    module label_shape(raised) {
        translate([0, 0, raised ? -text_relief : -eps])
            linear_extrude(height = text_relief + eps)
                intersection() {
                    translate([1, 1]) square([w - 2, face_depth - 2]);
                    translate([w / 2, face_depth / 2])
                        // compensate for viewing the outside of each folded face.
                        scale([1, flip_y ? -1 : 1])
                            translate([offset_x, offset_y])
                                rotate(angle) {
                                    if (right_value == "")
                                        text(value, size = size, font = text_font,
                                             halign = "center", valign = "center");
                                    else {
                                        translate([-w / 2 + 1, 0])
                                            text(value, size = size, font = text_font,
                                                 halign = "left", valign = "center");
                                        translate([w / 2 - 1, 0])
                                            text(right_value, size = size, font = text_font,
                                                 halign = "right", valign = "center");
                                    }
                                }
                }
    }
}

module side_wall() {
    yz_prism([
        [0, panel - eps],
        [d, panel - eps],
        [d, wall_top],
        [0, wall_top],
        [-rear_extension, wall_top - rear_extension],
        [-rear_extension, panel + rear_extension]
    ], wall);
}

module side_groove() {
    // clearance around the seated lip; only the closing motion interferes.
    reach = lip_interference_side + 0.15;
    translate([0, skirt_rear_setback - 0.3, groove_z])
        xz_prism([[-eps, -reach], [reach, 0], [-eps, reach]],
                 d - skirt_rear_setback + 0.3 + eps);
}

module perimeter_groove() {
    side_groove();
    translate([w, 0, 0]) mirror([1, 0, 0]) side_groove();
    reach = lip_interference + 0.15;
    translate([-eps, d, groove_z])
        yz_prism([[eps, -reach], [-reach, 0], [eps, reach]], w + 2 * eps);
}

module hub_lock() {
    translate([wall + clearance_xy + hub_lock_x,
               wall + clearance_xy + hub_lock_y, panel - eps])
        rotate([0, 0, hub_lock_angle]) {
            linear_extrude(height = hub_lock_height - hub_lock_tip_chamfer + eps)
                square([hub_lock_span, hub_lock_thickness], center = true);
            if (hub_lock_tip_chamfer > 0)
                translate([0, 0, hub_lock_height - hub_lock_tip_chamfer])
                    linear_extrude(height = hub_lock_tip_chamfer + eps,
                                   scale = [
                                       1 - 2 * hub_lock_tip_chamfer / hub_lock_span,
                                       1 - 2 * hub_lock_tip_chamfer / hub_lock_thickness
                                   ])
                        square([hub_lock_span, hub_lock_thickness], center = true);
        }
}

module base_shell() {
    difference() {
        union() {
            cube([w, d, panel]);
            side_wall();
            translate([w - wall, 0, 0]) side_wall();
            translate([0, d - wall, panel - eps])
                cube([w, wall, wall_top - panel + eps]);
        }
        perimeter_groove();
    }
    if (hub_lock_enabled) hub_lock();
}

module base() {
    exterior_label(back_text, back_text_mode, back_text_size,
                   back_text_rotation, back_text_x, back_text_y, d)
        base_shell();
}

module spine() {
    exterior_label(spine_text, spine_text_mode, spine_text_size,
                   spine_text_rotation, spine_text_x, spine_text_y, spine_length,
                   true, spine_text_right)
        cube([w, spine_length, panel]);
}

module side_lip() {
    translate([0, skirt_rear_setback, lip_z])
        xz_prism([
            [-skirt_clearance_side - eps, -lip_projection_side],
            [lip_interference_side, 0],
            [-skirt_clearance_side - eps, lip_projection_side]
        ], d + skirt_clearance_side - skirt_rear_setback + eps);
}

module perimeter_lip() {
    side_lip();
    translate([w, 0, 0]) mirror([1, 0, 0]) side_lip();
    translate([-skirt_clearance - eps, d, lip_z])
        yz_prism([
            [skirt_clearance + eps, -lip_projection],
            [-lip_interference, 0],
            [skirt_clearance + eps, lip_projection]
        ], w + 2 * skirt_clearance + 2 * eps);
}

module lid_shell() {
    translate([-skirt_outer_side, 0, 0])
        cube([w + 2 * skirt_outer_side, d + skirt_outer, panel]);
    for (x = [-skirt_outer_side, w + skirt_clearance_side])
        translate([x, skirt_rear_setback, panel - eps])
            cube([skirt_thickness, d + skirt_outer - skirt_rear_setback,
                  skirt_depth + eps]);
    translate([-skirt_outer_side, d + skirt_clearance, panel - eps])
        cube([w + 2 * skirt_outer_side, skirt_thickness, skirt_depth + eps]);
    perimeter_lip();
    if (pull_tab_enabled)
        translate([-skirt_outer_side, d + skirt_outer - eps, 0])
            cube([w + 2 * skirt_outer_side, pull_extension + eps, panel]);
}

module lid() {
    exterior_label(front_text, front_text_mode, front_text_size,
                   front_text_rotation, front_text_x, front_text_y, d, false)
        lid_shell();
}

module flat_web(y) {
    // ramps from panel thickness up at each rigid neighbor down to
    // hinge_thickness in the middle, instead of an abrupt step, so the
    // flex zone isn't a stress riser right where it meets rigid material.
    translate([hinge_end_inset, y, 0])
        yz_prism([
            [-eps, 0],
            [hinge_length + eps, 0],
            [hinge_length + eps, panel],
            [hinge_length - hinge_taper, hinge_thickness],
            [hinge_taper, hinge_thickness],
            [-eps, panel]
        ], hinge_width);
}

module flat_case() {
    union() {
        base();
        flat_web(-hinge_length);
        translate([0, -hinge_length - spine_length, 0])
            spine();
        flat_web(-fold_span);
        translate([0, -fold_span, 0]) mirror([0, 1, 0]) lid();
    }
}

module curved_web(upper = false) {
    // neutral-axis length is preserved; this is a geometric, not fatigue, model.
    angles = concat([-0.3], [for (a = [0 : 3 : 90]) a], [90.3]);
    points = concat(
        [for (a = angles)
            [-(bend_r - neutral_z) * sin(a),
             neutral_z + bend_r - (bend_r - neutral_z) * cos(a)]],
        [for (i = [len(angles) - 1 : -1 : 0])
            let(a = angles[i])
            [-(bend_r + neutral_z) * sin(a),
             neutral_z + bend_r - (bend_r + neutral_z) * cos(a)]]
    );
    if (upper)
        translate([0, 0, closed_height]) mirror([0, 0, 1]) curved_web();
    else
        translate([hinge_end_inset, 0, 0]) yz_prism(points, hinge_width);
}

module closed_case() {
    union() {
        base();
        curved_web();
        translate([0, -bend_r, neutral_z + bend_r])
            rotate([-90, 0, 0])
                translate([0, -spine_length, -neutral_z])
                    spine();
        curved_web(true);
        translate([0, 0, closed_height]) mirror([0, 0, 1]) lid();
    }
}

module hinge_test(closed = true) {
    rear = closed ? -bend_r - neutral_z - text_relief - eps : -fold_span - 18;
    intersection() {
        if (closed) closed_case();
        else flat_case();
        translate([-skirt_outer_side, rear, -text_relief - eps])
            cube([24, 18 - rear, closed_height + 2 * text_relief + 2 * eps]);
    }
}

if (layout == "flat")
    flat_case();
else if (layout == "closed")
    closed_case();
else if (layout == "hinge_test")
    hinge_test();
else
    hinge_test(false);

if (show_cassette && (layout == "flat" || layout == "closed"))
    %color([0.3, 0.6, 0.9, 0.5])
        translate([wall + clearance_xy, wall + clearance_xy, panel])
            difference() {
                cube([cassette_length, cassette_depth, cassette_thickness]);
                translate([hub_lock_x, hub_lock_y, -eps])
                    cylinder(h = cassette_thickness + 2 * eps,
                             d = sqrt(pow(hub_lock_span, 2) +
                                      pow(hub_lock_thickness, 2)) + 1);
            }
