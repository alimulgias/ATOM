import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MonitorsController {

	
	public static void main(String[] args) throws IOException {

		BufferedReader br = new BufferedReader(new FileReader(new File("filters.txt")));
		List<Monitor> monitors = new ArrayList<>();


		String tmp;
		while ((tmp = br.readLine()) != null) {

			String[] parts = tmp.split(",");
			Filter f = new Filter(parts[0], parts[1], parts[2]);
			monitors.add(new Monitor(f, new Reporter(args[0]),30,300,1200));//sample_interval, monitoring_window, burst_period
		}

		br.close();

		for (Monitor monitor : monitors) {

			new Thread(monitor).start();
		}

	}
}
