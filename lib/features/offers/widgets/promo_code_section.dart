import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/offers/controllers/my_offer_controller.dart';
import 'package:food_delivery/models/offermodel.dart';

class PromoCodeSection extends StatefulWidget {
  final double subtotal;
  final OfferModel? appliedOffer;
  final void Function(OfferModel? offer) onOfferChanged;

  const PromoCodeSection({
    super.key,
    required this.subtotal,
    required this.appliedOffer,
    required this.onOfferChanged,
  });

  @override
  State<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends State<PromoCodeSection> {
  final _codeController = TextEditingController();
  bool _isChecking = false;
  String? _error;



  Future<void> _applyCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isChecking = true;
      _error = null;
    });

    try {
      final controller = MyOffersController();
      final offer = await controller.validatePromoCode(code, widget.subtotal);
      debugPrint(
        'Promo lookup result: code=$code, offer=${offer?.title}, '
        'discountPercent=${offer?.discountPercent}, minOrder=${offer?.minOrderAmount}',
      );

      setState(() => _isChecking = false);

      if (offer == null) {
        setState(
          () => _error =
              'Invalid or expired code,  ',
        );
        widget.onOfferChanged(null);
      } else if (offer.discountPercent <= 0) {
        
        setState(
          () => _error =
              'Invalid or expired code, or code does not apply to this order',
        );
        widget.onOfferChanged(null);
      } else {
        widget.onOfferChanged(offer);
        _error = null;
      }
    } catch (e) {
      debugPrint('Promo code apply error: $e');
      setState(() {
        _isChecking = false;
        _error = 'Kuch ghalat hua: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Promo Code',
            style: GoogleSansRoundedStyles.bold(
              size: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
           SizedBox(height: size.height * 0.01),
          if (widget.appliedOffer != null)
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 18,
                ),
                 SizedBox(width: size.height * 0.01),
                Expanded(
                  child: Text(
                    '${widget.appliedOffer!.code} applied — ${widget.appliedOffer!.discountPercent.toInt()}% off',
                    style:  GoogleSansRoundedStyles.bold(
                      size: 14,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onOfferChanged(null);
                    _codeController.clear();
                  },
                  child:  Text('Remove'),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter code',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                 SizedBox(width: size.height * 0.01),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                  ),
                  onPressed: _isChecking ? null : _applyCode,
                  child: _isChecking
                      ?  SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      :  Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          if (_error != null) ...[
           SizedBox(height: size.height * 0.01),
            Text(
              _error!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
