class EmailService

  TYPE_CODE_REGISTER_EMAIL_CODE = 'REGISTER_EMAIL_CODE'

  # 构造方法
  def initialize(email)
    @email = email
  end


  def valid_register_email(type, ip)
    # unless Regular.is_mobile?(@email)
    #   return [FALSE, '邮箱格式错误']
    # end
    if EmailCode.where('created_at > ?', Time.now - 300).count > 10
      return [FALSE, '发送密度过大，请稍等重试']
    end
    code = rand(1000..9999) # 获取随机码
    row = EmailCode.find_by(email: @email, message_type: type) # 检测是否已经存在同类型记录
    if row.nil?
      EmailCode.create!(email: @email, code: code, message_type: type, ip: ip) # 如果不存在则直接生成新记录
    elsif row.updated_at + 2 * 60 < Time.now
      # 如果存在同类型记录，但已经超过发送间隔，则根据新的代码重新发送
      row.code = code
      row.save
    else
      # 如果存在同类型记录，但小于发送间隔，则不重新发送
      return [FALSE, '验证码发送间隔为2分钟']
    end
    status = true
    if status
      [TRUE, '验证码已发送到您的邮箱']
    else
      [TRUE, '验证码发送失败']
    end
    # status = FALSE
    # status = UserMailer.send_register_email_code(@email, code).deliver if type == TYPE_CODE_REGISTER_EMAIL_CODE
    # if status
    #   [TRUE, '验证码已发送到您的邮箱']
    # else
    #   [FALSE, '验证码发送失败']
    # end
  end

  # 检测手机验证码
  def validate?(code, type)

    # 检测邮箱验证码格式
    # unless Regular.is_mobile_code?(code)
    #   return [FALSE, '验证码格式或位数错误']
    # end

    # 获取验证码纪录，如果不存在返回 FALSE
    row = EmailCode.find_by(email: @email, message_type: type)
    # row = EmailCode.find_by(email: '273208426@qq.com', code: '12345', message_type: '123')
    if row.nil?
      return [FALSE, '不存在该邮箱的注册验证码']
    end

    if (row.updated_at + 10 * 60 < Time.now) or (row.failed_attempts.to_i + 1 >= 5) # 检测是否超时及是否超过尝试次数
      row.destroy
      return [FALSE, '验证码已超时或尝试失败超过5次']
    end


    #检测验证码是否正确，如不正确增加1次尝试次数
    if row.code == code
      row.destroy
      [TRUE, '验证码成功通过验证']
    else
      row.failed_attempts = row.failed_attempts.to_i + 1
      row.save
      [FALSE, '验证码错误']
    end
  end


end