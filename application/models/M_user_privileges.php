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

class M_user_privileges extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'user_privileges';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select('x1.id, x2.user_group, x3.module_name, x3.module_description, x3.module_url, x1.is_deleted');
		$this->db->join('user_groups x2', 'x1.user_group_id = x2.id', 'LEFT');
		$this->db->join('modules x3', 'x1.module_id = x3.id', 'LEFT');
		if ( ! empty($keyword) ) {
			$this->db->like('x2.user_group', $keyword);
			$this->db->or_like('x3.module_name', $keyword);
			$this->db->or_like('x3.module_description', $keyword);
			$this->db->or_like('x3.module_url', $keyword);
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Get user modules by user group id
	 * @param Integer $user_group_id
	 * @param Boolean $is_super_admin
	 * @param Boolean $is_admin
	 * @param Boolean $is_employee
	 * @param Boolean $is_student
	 * @return Array
	 */
	public function get_user_privileges($user_group_id, $is_super_admin, $is_admin, $is_employee, $is_student) {
		$user_privileges = ['dashboard', 'change_password'];
		if (filter_var($is_super_admin, FILTER_VALIDATE_BOOLEAN)) {
			array_push($user_privileges, 'maintenance', 'users', 'admission', 'appearance', 'blog', 'employees', 'media', 'plugins', 'reference', 'settings', 'academic', 'profile');
		}
		if (filter_var($is_admin, FILTER_VALIDATE_BOOLEAN)) {
			array_push($user_privileges, 'profile');
			$query = $this->db
				->select('x2.module_url')
				->join('modules x2', 'ON x1.module_id = x2.id', 'LEFT')
				->where('x1.user_group_id', $user_group_id)
				->where('x1.is_deleted', 'false')
				->get(self::$table.' x1');
			foreach ($query->result() as $row) {
				array_push($user_privileges, $row->module_url);
			}
		}
		if (filter_var($is_employee, FILTER_VALIDATE_BOOLEAN)) {
			array_push($user_privileges, 'employee_profile', 'posts', 'teacher');
		}
		if (filter_var($is_student, FILTER_VALIDATE_BOOLEAN)) {
			array_push($user_privileges, 'student_profile', 'scholarships', 'achievements', 'posts', 'student_presence', 'student_score');
		}
		return $user_privileges;
	}
}
