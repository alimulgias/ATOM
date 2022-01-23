import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;

import com.mathworks.engine.MatlabEngine;
import com.mathworks.engine.MatlabExecutionException;
import com.mathworks.engine.MatlabSyntaxException;

public class SolutionProvider {

	HashMap<String, List<Integer>> state;
	double[][] data;
	double[] values;

	public SolutionProvider(HashMap<String, List<Integer>> state) {
		// TODO Auto-generated constructor stub
		this.state = state;
	}

	private void callMatlab() throws InterruptedException, MatlabExecutionException, MatlabSyntaxException,
			CancellationException, ExecutionException {

		String path = "path-to-atom-folder";
		MatlabEngine eng = MatlabEngine.connectMatlab("matlabAtomEngine");
		eng.eval("addpath(genpath('" + path + "'));");
		values = eng.feval("provide_cont_resourceshare", (Object) data);
		eng.close();

		for (int i = 0; i < values.length; i++) {
			System.out.println(values[i]);
		}

	}

	private void createData() {

		String[] keyArray = { "get_home", "get_catalogue", "get_item", "get_cart", "delete_cart", "add_to_cart" };

		List<String> keys = Arrays.asList(keyArray);

		int samples = state.get(keyArray[0]).size();
		int serviceClass = keyArray.length;

		data = new double[samples][serviceClass];

		for (String key : keys) {
			List<Integer> partialData = state.get(key);
			int j = 0;
			for (Integer integer : partialData) {
				if (j < samples) {
					data[j][keys.indexOf(key)] = integer;
					j++;
				}
			}

		}

	}

	public void solve() {

		createData();
		try {
			callMatlab();
		} catch (CancellationException | InterruptedException | ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		new Thread(new ConfigSender(values)).start();

	}

}
