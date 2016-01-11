/**
 * Created by huaxiukun on 16/1/7.
 */
$(function () {
    $('#send-valid-register-email').on('click', function () {

            var email = $('#user_email').val();
            var type = $(this).attr('data-type');
            var email_format = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (email_format.test(email)) {
                $.ajax({
                    url: '/accounts/register_email_exists',
                    type: 'post',
                    data: {"email": email, "type": type},
                    success: function (data) {
                        if (data[0]) {
                            $('.email-exists').removeClass('hidden');
                            $('.error').text(data[1]);

                        } else {
                            $('.email-exists').addClass('hidden');
                            $('.error').text('');
                        }
                    }
                });
            }
            else {
                alert('邮箱格式不正确');
            }

        }
    )
});