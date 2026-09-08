/// One generic resource-cost line for a production session (e.g. "Gas"),
/// per erp.md's decision to keep this generic rather than a fixed
/// `biaya_gas` column.
class SessionCostInput {
  const SessionCostInput({required this.name, required this.amountRupiah});

  final String name;
  final int amountRupiah;
}
