deg = pi/180;
links = [
	    Revolute('d', 0.295, 'a', 0, 'alpha', -pi/2, 'offset', 0, 'qlim', [-240 240]*deg);
        Revolute('d', 0, 'a', -0.230, 'alpha', 0, 'offset', pi/2, 'qlim', [-120 120]*deg);
        Revolute('d', 0, 'a', -0.050, 'alpha', pi/2, 'offset', -pi/2, 'qlim', [0 160]*deg);
        Revolute('d', 0.27, 'a', 0, 'alpha', pi/2, 'offset', pi, 'qlim', [-200 200]*deg);
        Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'offset', pi, 'qlim', [-120 120]*deg);
        Revolute('d', 0.07, 'a', 0, 'alpha', 0, 'offset', 0, 'qlim', [-360 360]*deg);
	];

rv2f = SerialLink(links, 'name', 'Mitsubishi rv2f');
rv2f.base = trotz(0);
