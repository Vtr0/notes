var toHhMmSs = (sec) => {
    function pad(n, width, z) {
    	z = z || '0';
    	n = n + '';
    	return String(n).padStart(width, z); // '0009'
    }

	if (isNaN(sec)) return "00:00";
	sec = sec << 0; //make sec to be integer
	let h = (sec / 3600) << 0; sec = sec % 3600;
	let m = (sec / 60) << 0;
	s = sec % 60;
	return (h ? h + ":" : "") + pad(m, 2) + ":" + pad(s, 2);
}