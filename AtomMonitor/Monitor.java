import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class Monitor implements Runnable {

	Filter filter;
	Reporter reporter;
	long monitorWindow;
	long totalMonitorTime;
	long groupSize;
	long collectionDuration;

	public Monitor(Filter filter, Reporter reporter, long collectionDuration, long monitorWindow, long burstPeriod) {

		this.filter = filter;
		this.reporter = reporter;
		this.collectionDuration = collectionDuration; // seconds
		this.monitorWindow = monitorWindow;
		totalMonitorTime = burstPeriod + (collectionDuration / 2);
		groupSize = monitorWindow / collectionDuration;

	}

	@Override
	public void run() {

		while (totalMonitorTime > 0) {
			int count = 0;
			String linuxCommandResult = "";

			// System.out.println("Making Command");

			List<String> command = new ArrayList<>();

			command.add("timeout");
			command.add("" + collectionDuration);
			command.add("tcpdump");
			command.add("-i");
			command.add("docker_gwbridge");
			command.add("-A");
			command.add("tcp dst port 80 and " + filter.tcpFilter);

			String[] cmd = new String[command.size()];
			cmd = command.toArray(cmd);

			Process p = null;
			try {
				p = Runtime.getRuntime().exec(cmd);
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
			BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

			try {
				while ((linuxCommandResult = stdInput.readLine()) != null) {

					// System.out.println(linuxCommandResult);

				}

				while ((linuxCommandResult = stdError.readLine()) != null) {

					// System.out.println(linuxCommandResult);

					if (linuxCommandResult.contains("captured")) {
						String[] parts = linuxCommandResult.split("\\s+");
						count = Integer.parseInt(parts[0]);
					}

				}

			} catch (Exception e) {

				e.printStackTrace();
			}

			reporter.requestName = filter.requestName;
			reporter.values.add(count);

			System.out.println("Packets from " + filter.requestName + ": " + count);

			count = 0;

			if (reporter.values.size() == groupSize) {
				new Thread(reporter).start();

			}

			totalMonitorTime -= collectionDuration;
		}
	}

}
