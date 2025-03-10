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

class M_pollings extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'pollings';
	
	/**
	 * Insert
	 * @param Integer $answer_id
	 * @return Boolean
	 */
	public function insert($answer_id) {
		$count = $this->db
			->where('ip_address', $_SERVER['REMOTE_ADDR'])
			->where('LEFT(created_at, 10)=', date('Y-m-d'))
			->count_all_results(self::$table);
		if ($count === 0) {
			$this->db->set('answer_id', $answer_id);
			$this->db->set('ip_address', get_ip_address());
			$this->db->set('created_by', __session('user_id'));
			$query = $this->db->get_compiled_insert(self::$table);
			$query = str_replace('INSERT INTO', 'INSERT IGNORE INTO', $query);
			return $this->db->query($query);
		}
		return FALSE;
	}

	/**
	 * Polling Result
	 * @param Integer $question_id
	 * @return Resource
	 */
	public function get_pollings($question_id) {
		$this->db->select('x2.answer AS labels, COUNT(*) AS data');
		$this->db->join('answers x2', 'x1.answer_id = x2.id', 'LEFT');
		$this->db->where('x2.question_id', _toInteger($question_id));
		$this->db->group_by('x1.answer_id');
		$this->db->order_by('x1.answer_id', 'ASC');
		return $this->db->get(self::$table . ' x1');
	}
}
