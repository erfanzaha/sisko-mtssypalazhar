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

class M_users extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'users';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($user_type = '', $keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		if ( ! empty($user_type)) {
			if ($user_type == 'employee') $this->db->where('is_employee', 'true');
			else if ($user_type == 'student') $this->db->where('is_student', 'true');
			else if ($user_type == 'admin') $this->db->where('is_admin', 'true');
		}
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('nik', $keyword);
			$this->db->or_like('nis', $keyword);
			$this->db->or_like('full_name', $keyword);
			$this->db->or_like('phone', $keyword);
			$this->db->or_like('mobile_phone', $keyword);
			$this->db->or_like('email', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table);
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table);
	}

	/**
     * verify
     * @param String $email
     * @return Resource
     */
	public function verify($email) {
		return $this->db
			->where('email', $email)
			->where('is_deleted', 'false')
			->limit(1)
			->get(self::$table);
	}

	/**
     * last_active()
     * @param Integer $id
     * @return void
     */
	public function last_active($id) {
		$fields = [
			'last_active' => date('Y-m-d H:i:s'),
			'ip_address' => get_ip_address(),
			'active' => 'true'
		];
		$this->db
			->where(self::$pk, $id)
			->update(self::$table, $fields);
	}

	/**
     * reset_logged_in
     * set active to false
     * @param Integer $id
     * @return Void
     */
	public function reset_logged_in($id) {
		return $this->db
			->where(self::$pk, $id)
			->update(self::$table, ['active' => 'false']);
	}

	/**
     * get_attempts
     * @param String $ip_address
     * @return Object
     */
	public function get_attempts($ip_address) {
		$query = $this->db
			->where('ip_address', $ip_address)
			->get('login_attempts');
		if ($query->num_rows() === 1) {
			return $query->row();
		}
		return NULL;
	}

	/**
     * increase_login_attempts
     * @param String $ip_address
     * @return Void
     */
	public function increase_login_attempts($ip_address) {
		$query = $this->db
			->where('ip_address', $ip_address)
			->get('login_attempts');
		if ($query->num_rows() === 1) {
			$result = $query->row();
			return $this->db
				->where('ip_address', $ip_address)
				->update('login_attempts', ['counter' => ($result->counter + 1)]);
		}
		return $this->db->insert('login_attempts', ['ip_address' => $ip_address, 'counter' => 1]);
	}

	/**
     * Reset Attempts
     * @param String $ip_address
     * @return Void
     */
	public function reset_attempts($ip_address) {
		return $this->db
			->where('ip_address', $ip_address)
			->delete('login_attempts');
	}

	/**
     * get last logged in
     * @return Resource
     */
	public function get_last_login() {
		return $this->db
			->where('is_super_admin !=', 'false')
			->where('last_active IS NOT NULL')
			->order_by('last_active', 'DESC')
			->limit(10)
			->get(self::$table);
	}

	/**
     * Reset User Email
     * @param 	String $email
     * @return  Boolean
     */
	public function reset_email($email) {
		$user_id = __session('user_id');
		$count = $this->db
			->where('email', $email)
			->where('id <> ', $user_id)
			->count_all_results(self::$table);
		if ( $count == 0 ) {
			return $this->db
				->where('id', $user_id)
				->update(self::$table, ['email' => $email]);
		}
		return false;
	}

	/**
     * Set forgot password key
     * @param 	String $email
     * @param 	String $forgot_password_key
     * @return  Boolean
     */
	public function set_forgot_password_key($email, $forgot_password_key) {
		$dataset = [
			'forgot_password_key' => $forgot_password_key,
			'forgot_password_request_date' => date('Y-m-d H:i:s')
		];
		return $this->db
			->where('email', $email)
			->update(self::$table, $dataset);
	}

	/**
     * Remove Forgot Password Key
     * @param Integer $id
     * @return Boolean
     */
	public function remove_forgot_password_key($id) {
		return $this->db
			->where(self::$pk, $id)
			->update(self::$table, [
				'forgot_password_key' => NULL,
				'forgot_password_request_date' => NULL
			]);
	}

	/**
     * Reset Password
     * @param String $id
     * @return Boolean
     */
	public function reset_password( $id ) {
		return $this->db
			->where(self::$pk, $id)
			->update(self::$table, [
				'forgot_password_key' => NULL,
				'forgot_password_request_date' => NULL,
				'password' => password_hash($this->input->post('password', true), PASSWORD_BCRYPT, ['cost' => 12])
			]);
	}

	/**
     * Get user by email
     * @param String $email
     * @return Any
     */
	public function get_user_by_email($email) {
		$query = $this->db
			->where('email', $email)
			->get(self::$table);
		if ($query->num_rows() === 1) {
			$result = $query->row();
			return [
				'email' => $result->email,
				'full_name' => $result->full_name
			];
		}
		return NULL;
	}

	/**
	 * Check if email exists
	 * @param String $email
	 * @param Integer $id
	 * @return Boolean
	 */
	public function email_exists( $email = '', $id = 0 ) {
		$this->db->where('email', $email);
		if ( _isNaturalNumber($id) ) $this->db->where('id <>', _toInteger($id));
		$count = $this->db->count_all_results(self::$table);
		return $count > 0;
	}

	/**
	 * NIS Exists ?
	 * @param Integer $nis
	 * @param Integer $id
	 * @return Boolean
	 */
	public function nis_exists($nis, $id = 0) {
		$this->db->where('nis', $nis);
		if ( _isNaturalNumber($id) ) $this->db->where('id <>', _toInteger($id));
		$this->db->where('is_deleted', 'false');
		$count = $this->db->count_all_results(self::$table);
		return $count > 0;
	}

	/**
	 * Dropdown
	 * @return Array
	 */
	public function dropdown($user_type = 'admin') {
		$this->db->select('id, nik, full_name');
		if ($user_type === 'admin') $this->db->where('is_admin', 'true');
		else if ($user_type === 'employee') $this->db->where('is_employee', 'true');
		else if ($user_type === 'student') $this->db->where('is_student', 'true');
		$this->db->where('is_deleted', 'false');
		$this->db->order_by('full_name', 'ASC');
		$query = $this->db->get(self::$table);
		$data = [];
		if ($query->num_rows() > 0) {
			foreach($query->result() as $row) {
				$data[$row->id] = $row->nik .' - '. $row->full_name;
			}
		}
		return $data;
	}

	/**
	 * Activate account
	 * @param String $email
	 * @return Void
	 */
	public function activate_account($email = '') {
		if ( ! empty($email)) {
			$query = $this->db
				->select('id, password, birth_date')
				->where('email', $email)
				->get(self::$table);
			if ($query->num_rows() === 1) {
				$row = $query->row();
				if ((is_null($row->password) || empty($row->password) && _isValidDate($row->birth_date))) {
					$this->db->set('password', password_hash($row->birth_date, PASSWORD_BCRYPT, ['cost' => 12]));
					$this->db->set('updated_by', __session('user_id'));
					$this->db->where(self::$pk, $row->id);
					$this->db->update(self::$table);
				}
			}
		}
	}
}
