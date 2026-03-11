module ApplicationHelper
  def qr_code_as_svg(url)
    qrcode = RQRCode::QRCode.new(url)
    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
