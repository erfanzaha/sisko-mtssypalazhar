<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class Auth {

	/**
	 * Reference to CodeIgniter instance
	 *
	 * @var object
	 */
	protected $CI;

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		$this->CI = &get_instance();
		$this->CI->load->model([
			'm_users',
			'm_user_privileges',
			'm_students'
		]);
	}

	/**
	 * verify
	 * @param String $email
	 * @param String $password
	 * @param String $ip_address
	 * @return Boolean
	 */
	public function verify($email, $password, $ip_address) {
		$ip_banned = $this->ip_banned($ip_address);
		if ( ! $ip_banned ) {
			$query = $this->CI->m_users->verify($email);
			if ($query->num_rows() === 1) {
				$data = $query->row();
				if (password_verify($password, $data->password)) {
					$session_data = [
						'user_id' => $data->id,
						'email' => $data->email,
						'full_name' => $data->full_name,
						'is_super_admin' => filter_var($data->is_super_admin, FILTER_VALIDATE_BOOLEAN),
						'is_admin' => filter_var($data->is_admin, FILTER_VALIDATE_BOOLEAN),
						'is_employee' => filter_var($data->is_employee, FILTER_VALIDATE_BOOLEAN),
						'is_prospective_student' => filter_var($data->is_prospective_student, FILTER_VALIDATE_BOOLEAN),
						'is_student' => filter_var($data->is_student, FILTER_VALIDATE_BOOLEAN),
						'is_alumni' => filter_var($data->is_alumni, FILTER_VALIDATE_BOOLEAN),
						'active' => true,
						'user_privileges' => $this->CI->m_user_privileges->get_user_privileges($data->user_group_id, $data->is_super_admin, $data->is_admin, $data->is_employee, $data->is_student)
					];
					if (filter_var($data->is_employee, FILTER_VALIDATE_BOOLEAN)) {
						$employment_type_id = $data->employment_type_id;
						$employment_type = $this->CI->model->RowObject('id', $employment_type_id, 'options');
						$session_data['employment_type'] = $employment_type->option_name;
						if (strpos(strtolower($employment_type->option_name), 'guru')) {
							$session_data['is_teacher'] = true;
						}
					}					
					$this->CI->session->set_userdata($session_data);
					$this->last_active($data->id);
					$this->reset_attempts($ip_address);
					return true;
				}
				return false;
			}
			$this->increase_login_attempts($ip_address);
			return false;
		}
		return false;
	}

	/**
	 * Last Active
	 * Fungsi untuk mengupdate data login terakhir
	 * @param Integer $id
	 * @return Void
	 */
	private function last_active($id) {
		$this->CI->m_users->last_active($id);
	}

	/**
	 * Logged In
	 * Fungsi untuk mengecek apakah data session user id kosong / tidak
	 * @return Boolean
	 */
	public function logged_in() {
		return (bool) __session('active');
	}

	/**
	 * Restrict
	 * Fungsi untuk validasi status login
	 * @return Boolean
	 */
	public function restrict() {
		if ( ! $this->logged_in()) {
			return redirect('login', 'refresh');
		}
	}

	/**
	 * check if user has ban by ip address
	 * @param String $ip_address
	 * @return Boolean
	 */
	public function ip_banned($ip_address) {
		$max_attempts = 3;
		$banned_time = 600; // 600 || Banned at 10 minutes
		$query = $this->CI->m_users->get_attempts($ip_address);
		if (is_object($query) && $query->counter >= $max_attempts) {
			$datetime = strtotime($query->updated_at);
			$time_diff = time() - $datetime;
			if ($time_diff >= $banned_time) {
				$this->reset_attempts($ip_address);
				return false;
			}
			return true;
		}
		return false;
	}

	/**
	 * Increase Login Attempts
	 * @param String $ip_address
	 * @return Void
	 */
	private function increase_login_attempts($ip_address) {
		$this->CI->m_users->increase_login_attempts($ip_address);
	}

	/**
	 * Reset Login Attempts
	 * Fungsi untuk menghapus data login attempts
	 * @param String $ip_address
	 * @return Void
	 */
	private function reset_attempts($ip_address) {
		$this->CI->m_users->reset_attempts($ip_address);
	}
}
