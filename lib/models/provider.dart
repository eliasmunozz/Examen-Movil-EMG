class ProviderModel {
  int providerId;
  String providerName;
  String providerLastName;
  String providerMail;
  String providerState;

  ProviderModel({
    required this.providerId,
    required this.providerName,
    required this.providerLastName,
    required this.providerMail,
    required this.providerState,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        providerId: json['providerid'], 
        providerName: json['provider_name'],
        providerLastName: json['provider_last_name'],
        providerMail: json['provider_mail'],
        providerState: json['provider_state'],
      );

  Map<String, dynamic> toJson() => {
        'provider_id': providerId, 
        'provider_name': providerName,
        'provider_last_name': providerLastName,
        'provider_mail': providerMail,
        'provider_state': providerState,
      };
}