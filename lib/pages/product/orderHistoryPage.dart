import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/models/order_model.dart';
import 'package:proyekakhir/services/hive_service.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  // Load order history dari Hive
  Future<void> _loadOrderHistory() async {
    try {
      final orderList = await HiveService.getAllOrders();
      setState(() {
        orders = orderList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading order history: $e')),
      );
    }
  }

  // Refresh order history
  Future<void> _refreshOrderHistory() async {
    setState(() {
      isLoading = true;
    });
    await _loadOrderHistory();
  }

  // Get status color berdasarkan status pesanan
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'selesai':
        return Colors.green;
      case 'pending':
      case 'dalam proses':
        return Colors.orange;
      case 'cancelled':
      case 'dibatalkan':
        return Colors.red;
      case 'shipped':
      case 'dikirim':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Get status text dalam bahasa Indonesia
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'pending':
        return 'Dalam Proses';
      case 'cancelled':
        return 'Dibatalkan';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Selesai';
      default:
        return status;
    }
  }

  // Show order detail dialog
  void _showOrderDetail(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Detail Pesanan',
            style: AppFont.nunitoSansBold.copyWith(color: AppColor.primary),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Info
                _buildDetailRow('Order ID', order.orderId),
                _buildDetailRow('Tanggal', order.formattedDate),
                _buildDetailRow('Status', _getStatusText(order.status)),
                _buildDetailRow('Nama Pelanggan', order.customerName ?? '-'),
                _buildDetailRow('No. Telepon', order.customerPhone ?? '-'),
                _buildDetailRow('Alamat', order.shippingAddress),
                _buildDetailRow('Metode Pembayaran', order.paymentMethod),
                const Divider(height: 20),

                // Items
                Text(
                  'Items (${order.items.length})',
                  style: AppFont.nunitoSansSemiBold.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),

                // Items list
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: order.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              item.productImage,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  color: AppColor.grayWafer.withOpacity(0.3),
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: AppFont.nunitoSansSemiBold.copyWith(
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${item.quantity}x ${formatIDRCurrency(number: item.productPrice.toInt())}',
                                  style: AppFont.nunitoSansRegular.copyWith(
                                    fontSize: 11,
                                    color: AppColor.grayWafer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const Divider(height: 20),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pembayaran:',
                      style: AppFont.nunitoSansBold.copyWith(fontSize: 16),
                    ),
                    Text(
                      formatIDRCurrency(number: order.totalPrice.toInt()),
                      style: AppFont.nunitoSansBold.copyWith(
                        fontSize: 16,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tutup',
                style: AppFont.nunitoSansSemiBold.copyWith(
                  color: AppColor.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper untuk membuat row detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 12,
                color: AppColor.grayWafer,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFont.nunitoSansRegular.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Pesanan',
          style: AppFont.nunitoSansBold.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _refreshOrderHistory,
            icon: const Icon(Icons.refresh, color: AppColor.white),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColor.grayWafer,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat pesanan',
                    style: AppFont.nunitoSansSemiBold.copyWith(
                      fontSize: 18,
                      color: AppColor.grayWafer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pesanan yang telah dibuat akan muncul di sini',
                    style: AppFont.nunitoSansRegular.copyWith(
                      color: AppColor.grayWafer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshOrderHistory,
              child: ListView.builder(
                itemCount: orders.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final statusColor = _getStatusColor(order.status);
                  final statusText = _getStatusText(order.status);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: InkWell(
                      onTap: () => _showOrderDetail(order),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    order.orderId,
                                    style: AppFont.nunitoSansSemiBold.copyWith(
                                      fontSize: 16,
                                      color: AppColor.dark,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: AppFont.nunitoSansSemiBold.copyWith(
                                      fontSize: 12,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Tanggal: ${order.formattedDate}',
                              style: AppFont.nunitoSansRegular.copyWith(
                                fontSize: 14,
                                color: AppColor.gray,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              '${order.items.length} item${order.items.length > 1 ? 's' : ''} • ${order.paymentMethod}',
                              style: AppFont.nunitoSansRegular.copyWith(
                                fontSize: 12,
                                color: AppColor.grayWafer,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: AppFont.nunitoSansRegular.copyWith(
                                    fontSize: 14,
                                    color: AppColor.gray,
                                  ),
                                ),
                                Text(
                                  formatIDRCurrency(
                                    number: order.totalPrice.toInt(),
                                  ),
                                  style: AppFont.nunitoSansBold.copyWith(
                                    fontSize: 16,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Tap untuk detail',
                                  style: AppFont.nunitoSansRegular.copyWith(
                                    fontSize: 11,
                                    color: AppColor.primary.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: AppColor.primary.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
