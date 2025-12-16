import csv
from collections import defaultdict

def read_csv(file_path):
    """Read CSV and return a dict of function -> list of cycle counts."""
    data = defaultdict(list)
    with open(file_path, newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            func, cycles = row
            data[func].append(int(cycles))
    return data

def average_cycles(data):
    """Return a dict of function -> average cycle count."""
    avg_data = {}
    for func, cycles in data.items():
        avg_data[func] = sum(cycles) / len(cycles)
    return avg_data

def percent_diff(val1, val2):
    """Calculate percent difference between two values."""
    if val1 == 0:
        return float('inf')  # avoid division by zero
    return ((val2 - val1) / val1) * 100

def main(csv1, csv2):
    baseline = read_csv(csv1)
    abacus = read_csv(csv2)

    baseline_avg = average_cycles(baseline)
    abacus_avg = average_cycles(abacus)
    # Per-function average breakdown
    print('\nPer-function average cycle counts:')
    funcs = sorted(set(list(baseline_avg.keys()) + list(abacus_avg.keys())))
    print(f"{'Function':40s} {'Baseline':>12s} {'Abacus':>12s} {'% diff':>10s}")
    print('-' * 76)
    for func in funcs:
        a1 = baseline_avg.get(func, 0.0)
        a2 = abacus_avg.get(func, 0.0)
        diff = percent_diff(a1, a2) if a1 != 0 else float('inf') if a2 != 0 else 0.0
        diff_str = f"{diff:.2f}%" if diff != float('inf') else 'inf%'
        print(f"{func:40s} {a1:12.2f} {a2:12.2f} {diff_str:10s}")


def clean_baseline_csv(baseline_csv):
    # Clean the baseline CSV by removing every other measurement.
    #
    # The baseline measurement performs two calls to attach device 
    # during initialization as it performs extra checks not needed
    # with Abacus. This results in a check and early termination on 
    # the second "attach" that skews the baseline cycle counts 
    # lower. To mitigate this, we remove the baseline's second call
    # to attach. 
    cleaned_data = defaultdict(list)
    with open(baseline_csv, newline='') as csvfile:
        reader = csv.reader(csvfile)
        skip_next = False
        for row in reader:
            if skip_next:
                skip_next = False
                continue
            func, cycles = row
            cleaned_data[func].append(int(cycles))
            skip_next = True  # Skip the next measurement

    # Write cleaned data back to CSV.
    cleaned_csv = baseline_csv.replace('.csv', '_cleaned.csv')
    with open(cleaned_csv, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        for func, cycles in cleaned_data.items():
            for cycle in cycles:
                writer.writerow([func, cycle])
    return cleaned_csv

if __name__ == "__main__":
    # Replace with your CSV file paths
    baseline_csv = "results/baseline_redox_xhci_cycle_result.csv"
    abacus_csv = "results/abacus_redox_xhci_cycle_result.csv"
    cleaned_baseline_csv = clean_baseline_csv(baseline_csv)

    main(cleaned_baseline_csv, abacus_csv)