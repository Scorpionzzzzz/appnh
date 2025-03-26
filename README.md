# EASIBANK

Ứng dụng ngân hàng di động đơn giản.

## Hướng dẫn build iOS app

### Sử dụng Codemagic (Khuyến nghị)

1. Đăng ký tài khoản tại [Codemagic](https://codemagic.io/start/)
2. Kết nối repository GitHub của bạn với Codemagic
3. Chọn workflow `ios-workflow` từ file `codemagic.yaml`
4. Nhấn "Start new build"
5. Sau khi build xong, bạn có thể tải file IPA về máy

### Cài đặt IPA trên thiết bị iOS

1. Tải file IPA từ Codemagic
2. Cài đặt [AltStore](https://altstore.io/) trên máy tính
3. Kết nối iPhone với máy tính
4. Mở AltStore và cài đặt file IPA

## Lưu ý

- Đây là ứng dụng demo, không cần quan tâm đến bản quyền
- File IPA được build không có chữ ký số, nên cần cài đặt thông qua AltStore
- Thời gian build có thể mất 10-15 phút
